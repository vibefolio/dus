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
  end

  def pricing
  end

  def create_quote
    @quote = Quote.new(quote_params)
    @quote.status = "pending"

    if @quote.save
      # Send email notifications
      begin
        QuoteMailer.new_quote_notification(@quote).deliver_later
        QuoteMailer.quote_confirmation(@quote).deliver_later
      rescue => e
        Rails.logger.error "Failed to send quote emails: #{e.message}"
      end
      
      redirect_to contact_path, notice: "문의가 성공적으로 접수되었습니다. 빠른 시일 내에 연락드리겠습니다."
    else
      render :contact, status: :unprocessable_entity
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
    params.require(:quote).permit(:contact_name, :company_name, :email, :phone, :project_type, :budget, :message)
  end
end
