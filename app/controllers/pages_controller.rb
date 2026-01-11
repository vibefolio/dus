class PagesController < ApplicationController
  def home
    begin
      all_templates = YAML.load_file(Rails.root.join('config', 'templates.yml'))
      @featured_templates = all_templates.select { |t| t["is_featured"] }.take(3).each_with_index.map do |t, idx|
        OpenStruct.new(t).tap do |os|
          os.id = idx + 1000 # Dummy ID
          os.pc_thumbnail_url = os.image_url.presence || '/images/templates/portfolio_gallery.png'
          os.mobile_thumbnail_url = os.mobile_image_url.presence || os.pc_thumbnail_url
        end
      end
    rescue => e
      Rails.logger.error "Home featured templates error: #{e.message}"
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
        # Try DB first
        @target_template = DesignTemplate.find(params[:template_id])
        @preview_url = @target_template.preview_url
        @preview_title = @target_template.title
      rescue ActiveRecord::RecordNotFound, ActiveRecord::StatementInvalid, ActiveRecord::ConnectionNotEstablished
        # Fallback to Static YAML
        begin
          all_templates = YAML.load_file(Rails.root.join('config', 'templates.yml'))
          # Assuming template_id matches idx + 1 from the map in DesignTemplatesController
          found = all_templates.each_with_index.find { |t, idx| idx + 1 == params[:template_id].to_i }
          if found
            t, idx = found
            @target_template = OpenStruct.new(t)
            @target_template.id = idx + 1
            @preview_url = @target_template.preview_url
            @preview_title = @target_template.title
          end
        rescue => static_e
          Rails.logger.error "Static Template fallback failed: #{static_e.message}"
        end
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
        
        # Normal success path if @quote.save worked
        flash[:notice] = "문의가 성공적으로 접수되었습니다. 담당자가 확인 후 연락드리겠습니다."
        redirect_to contact_path
      else
        flash.now[:alert] = "입력하신 정보를 다시 확인해주세요."
        render :contact, status: :unprocessable_entity
        return
      end
    rescue => e
      # Database connection error (e.g. Render DB expired) or other critical save error
      Rails.logger.error "CRITICAL: Inquiry DB write failed, logging to file instead: #{e.message}"
      Rails.logger.info "INQUIRY DATA: #{quote_params.to_h}"
      
      # We still want to give the user a 'Success' feedback or at least not a 500
      flash[:notice] = "문의가 접수되었습니다. (시스템 점검 중으로 확인 후 연락드리겠습니다.)"
      redirect_to contact_path
      return
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
