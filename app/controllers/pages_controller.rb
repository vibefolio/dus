class PagesController < ApplicationController
  def home
    begin
      @featured_templates = Rails.cache.fetch("featured_templates", expires_in: 1.hour) do
        DesignTemplate.where(is_featured: true).limit(3).to_a
      end
    rescue => e
      Rails.logger.error "Failed to load featured templates: #{e.message}"
      @featured_templates = []
    end
  end

  def portfolio
    begin
      @portfolios = Portfolio.order(created_at: :desc)
    rescue => e
      Rails.logger.error "Failed to load portfolios: #{e.message}"
      @portfolios = []
    end
  end

  def contact
    @quote = Quote.new
    
    # DB 기반 템플릿 데이터 로드 (하드코딩 제거)
    if params[:template_id].present?
      begin
        @target_template = DesignTemplate.find(params[:template_id])
        @preview_url = @target_template.preview_url
        @preview_title = @target_template.title
      rescue ActiveRecord::RecordNotFound
        # 혹시라도 DB에 없는 ID가 넘어오면 조용히 일반 문의 모드로
        @target_template = nil
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

  def debug_error
    begin
      count = DesignTemplate.count
      render plain: "Success! DesignTemplate count: #{count}"
    rescue => e
      render plain: "Error: #{e.class} - #{e.message}\n\nBacktrace:\n#{e.backtrace.join("\n")}", status: :internal_server_error
    end
  end

  def create_quote
    begin
      @quote = Quote.new(quote_params)
      @quote.status = "pending"

      if @quote.save
        # Send email notifications safely
        begin
          QuoteMailer.new_quote_notification(@quote).deliver_now
          QuoteMailer.quote_confirmation(@quote).deliver_now
        rescue => e
          Rails.logger.error "이메일 발송 실패: #{e.message}"
          # 이메일 실패는 사용자에게 치명적이지 않으므로 무시하고 진행
        end
        
        redirect_to contact_path, notice: "문의가 성공적으로 접수되었습니다. 빠른 시일 내에 연락드리겠습니다."
      else
        flash.now[:alert] = "입력하신 정보를 다시 확인해주세요."
        render :contact, status: :unprocessable_entity
      end
    rescue => e
      Rails.logger.error "문의 접수 중 오류 발생: #{e.message}"
      flash.now[:alert] = "일시적인 오류로 문의 접수에 실패했습니다. 잠시 후 다시 시도해주세요."
      @quote = Quote.new(quote_params) # 폼 데이터 유지를 위해
      render :contact, status: :internal_server_error
    end
  end

  def robots
    robots_txt = <<~TEXT
      User-agent: *
      Allow: /
      Disallow: /admin
      Disallow: /templates/*
      Sitemap: #{request.base_url}/sitemap.xml
    TEXT
    render plain: robots_txt
  end

  def sitemap
    @base_url = request.base_url
    begin
      @templates = DesignTemplate.all
      @portfolios = Portfolio.all
    rescue => e
      Rails.logger.error "Failed to load data for sitemap: #{e.message}"
      @templates = []
      @portfolios = []
    end
    
    render formats: :xml
  end

  private

  def quote_params
    params.require(:quote).permit(:contact_name, :company_name, :email, :phone, :project_type, :budget, :message, :preferred_domain)
  end
end
