require "ostruct"

class PagesController < ApplicationController
  def home
    begin
      @featured_templates = DesignTemplate.all_combined.select(&:is_featured).take(3)
    rescue => e
      Rails.logger.error "Home featured templates error: #{e.message}"
      @featured_templates = []
    end
    @recent_portfolios = Portfolio.order(project_date: :desc).limit(6)
  end

  def portfolio
    cached = Rails.cache.fetch("portfolio_page_data", expires_in: 10.minutes) do
      all = Portfolio.with_attached_image.with_attached_mobile_image.order(created_at: :desc).to_a
      category_order = ["앱 및 플랫폼", "프랜차이즈 플랫폼"]
      regular = all.reject { |p| p.category == "협업" }
      groups = regular.group_by(&:category).sort_by { |cat, _| category_order.index(cat) || category_order.length }
      collabs = all.select { |p| p.category == "협업" }.sort_by { |p| [p.collab_partner.to_s, p.project_date.to_s] }.group_by(&:collab_partner)
      { groups: groups, collabs: collabs }
    end
    @portfolio_groups = cached[:groups]
    @collab_groups = cached[:collabs]
  rescue => e
    Rails.logger.error "Failed to load portfolios: #{e.message}"
    @portfolio_groups = []
    @collab_groups = {}
  end

  def contact
    @quote = Quote.new
    
    # Static data fallback for template lookup
    if params[:template_id].present?
      @target_template = DesignTemplate.all_static.find { |t| t.id == params[:template_id].to_i }
      if @target_template
        @preview_url = @target_template.preview_url
        @preview_title = @target_template.title
      end
    end

    # 직접 URL 파라미터가 넘어오면 우선 적용 (안전 장치)
    if params[:preview_url].present?
      @preview_url = params[:preview_url]
    end
    
    # 템플릿 제목도 파라미터가 있다면 우선 적용
    if params[:template_title].present?
      @preview_title = params[:template_title]
    end
  end

  def pricing
  end

  def privacy
  end

  def terms
  end

  def majortax
    @quote = Quote.new
  end

  # 광고 유입 전용 랜딩. 실제 운영 중인 사이트를 근거로 보여주므로 포트폴리오를 함께 넘긴다.
  def start
    @quote = Quote.new
    @live_sites = live_sites_for_landing
    @live_total = Portfolio.count
  rescue => e
    Rails.logger.error "[StartLanding] 포트폴리오 로드 실패: #{e.message}"
    @live_sites = []
    @live_total = 0
  end

  def create_start_quote
    if params[:quote][:nickname].present?
      flash[:notice] = "문의가 접수되었습니다."
      return redirect_to start_path
    end

    @quote = Quote.new(quote_params)
    @quote.status = "pending"
    @quote.source = "ad_landing"
    @quote.project_type = params[:quote][:project_type].presence || "홈페이지 제작"
    @quote.user = current_user if user_signed_in?

    if @quote.save
      deliver_quote_emails_safely(@quote)
      flash[:notice] = "문의가 접수되었습니다! 영업일 기준 24시간 이내 연락드리겠습니다."
      redirect_to start_path
    else
      @live_sites = live_sites_for_landing
      @live_total = Portfolio.count
      render :start, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error "[StartQuote] #{e.message}"
    flash[:alert] = "일시적인 오류로 문의 접수에 실패했어요. 번거로우시겠지만 duscontactus@gmail.com 으로 보내주시면 바로 확인하겠습니다."
    redirect_to start_path
  end

  def create_majortax_quote
    if params[:quote][:nickname].present?
      flash[:notice] = "문의가 접수되었습니다."
      return redirect_to majortax_path
    end

    @quote = Quote.new(quote_params)
    @quote.status = "pending"
    @quote.source = "majortax"
    @quote.project_type = "세무기장+홈페이지 패키지"
    @quote.user = current_user if user_signed_in?

    if @quote.save
      deliver_quote_emails_safely(@quote)
      flash[:notice] = "상담 신청이 완료되었습니다! 24시간 이내 연락드리겠습니다."
      redirect_to majortax_path
    else
      render :majortax, status: :unprocessable_entity
    end
  rescue => e
    # 저장에 실패했는데 완료라고 안내하면 상담 신청이 조용히 유실된다. 사실대로 알리고 직접 연락 경로를 준다.
    Rails.logger.error "[MajortaxQuote] #{e.message}"
    flash[:alert] = "일시적인 오류로 상담 신청에 실패했어요. 번거로우시겠지만 duscontactus@gmail.com 으로 보내주시면 바로 확인하겠습니다."
    redirect_to majortax_path
  end

  def create_quote
    # Honeypot check: Bots will fill 'nickname' which is hidden from human users
    if params[:quote][:nickname].present?
      Rails.logger.warn "SPAM PREVENTED: Honeypot field filled by #{params[:quote][:email]}"
      flash[:notice] = "문의가 접수되었습니다." # Fake success message to not alert the bot
      return redirect_to contact_path
    end

    begin
      @quote = Quote.new(quote_params)
      @quote.agency = @current_agency if @current_agency
      @quote.status = "pending"
      @quote.workflow_status ||= "received"
      @quote.created_at = Time.current # Ensure it has a timestamp for the mailer
      
      if user_signed_in?
        @quote.user = current_user
      else
        @quote.guest_session_id = cookies.signed[:guest_id]
      end

      if @quote.save
        # 저장이 끝난 뒤의 메일 발송은 "알림"일 뿐이다.
        # 여기서 예외가 새어나가면 아래 rescue 가 저장 실패로 오인해 고객에게 실패 안내를 하게 된다
        # (2026-08-10 실제 발생: SMTP 인증 오류인데 "문의 접수에 실패했어요" 노출)
        deliver_quote_emails_safely(@quote)

        if user_signed_in?
          flash[:notice] = "문의가 성공적으로 접수되었습니다. 담당자가 확인 후 연락드리겠습니다."
        else
          flash[:notice] = "문의가 접수되었습니다. 회원가입을 하시면 상담 내역을 연동하여 확인하실 수 있습니다."
        end
        redirect_to contact_path
      else
        render :contact, status: :unprocessable_entity
      end
    rescue => e
      # Database connection error (e.g. Render DB expired)
      Rails.logger.error "CRITICAL: Inquiry DB write failed, fallback to email only: #{e.message}"
      
      # Mock the object for the mailer since DB save failed
      @fallback_quote = OpenStruct.new(quote_params)
      @fallback_quote.created_at = Time.current
      
      # Try to send email even if DB is down
      begin
        send_quote_emails(@fallback_quote)
        flash[:notice] = "문의가 접수되었습니다. (시스템 점검 중이나 메일로 정상 접수되었습니다.)"
      rescue => mail_e
        # DB·메일 양쪽 다 실패 = 문의가 어디에도 남지 않는다.
        # 접수됐다고 안내하면 고객은 기다리기만 하고 리드는 조용히 사라진다. 사실대로 알리고 직접 연락 경로를 준다.
        Rails.logger.error "Email delivery also failed: #{mail_e.message}"
        flash[:alert] = "일시적인 오류로 문의 접수에 실패했어요. 번거로우시겠지만 duscontactus@gmail.com 으로 보내주시면 바로 확인하겠습니다."
      end

      redirect_to contact_path
    end
  end

  # SEO: robots.txt
  def robots
    # ⚠️ 이 액션은 실제로는 호출되지 않는다. public/robots.txt 정적 파일이 라우트보다 먼저 서빙된다.
    #    (2026-08-08 확인) 내용 변경 시 public/robots.txt 를 함께 고칠 것.
    #
    # /templates/* 는 업종별 데모 페이지라 색인을 막으면 "카페 홈페이지 제작" 같은
    # 업종 롱테일 검색 유입을 스스로 차단하게 된다 — 막지 않는다.
    robots_txt = <<~TEXT
      User-agent: *
      Allow: /
      Disallow: /admin
      Disallow: /users
      Disallow: /cart
      Disallow: /mypage
      Disallow: /orders
      Sitemap: #{request.base_url}/sitemap.xml
    TEXT
    render plain: robots_txt
  end

  # SEO: sitemap.xml
  def sitemap
    @base_url = request.base_url
    begin
      @templates = DesignTemplate.all_static
      @portfolios = [] # Database is down, no static data for portfolios yet
    rescue => e
      Rails.logger.error "Failed to load data for sitemap: #{e.message}"
      @templates = []
      @portfolios = []
    end

    render formats: :xml
  end

  private

  def send_quote_emails(quote)
    QuoteMailer.new_quote_notification(quote).deliver_now
    QuoteMailer.quote_confirmation(quote).deliver_now
  end

  # DB 저장이 끝난 뒤 쓰는 발송 헬퍼.
  # 문의는 이미 DB와 어드민에 남았으므로, 메일이 안 나갔다고 해서 고객에게 실패라고 하면 안 된다.
  # 대신 관리자가 알아챌 수 있도록 로그에 크게 남긴다.
  def deliver_quote_emails_safely(quote)
    send_quote_emails(quote)
    true
  rescue => e
    Rails.logger.error "[MAIL FAILED] 문의 ##{quote.try(:id)} 는 저장됐으나 알림 메일 발송 실패: #{e.class} #{e.message}"
    false
  end

  # 광고 랜딩의 "실제 운영 중" 섹션에 쓸 사이트.
  # 자사 서비스(계발자들)가 아니라 실제 고객사 사이트만 골라야 근거로서 힘이 있다.
  def live_sites_for_landing(limit = 8)
    Portfolio
      .where.not(preview_url: [nil, ""])
      .where.not(client: "계발자들 (Vibers)")
      .order(project_date: :desc)
      .limit(limit)
  end

  def quote_params
    # nickname은 허니팟 필드 — Quote 모델에 없으므로 제외
    params.require(:quote).permit(:contact_name, :company_name, :email, :phone, :project_type, :budget, :message, :preferred_domain)
  end
end
