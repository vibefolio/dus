class PagesController < ApplicationController
  def home
    @featured_templates = DesignTemplate.where(is_featured: true).limit(3)
  end

  def portfolio
    @portfolios = Portfolio.order(created_at: :desc)
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
    @templates = DesignTemplate.all
    @portfolios = Portfolio.all
    
    render formats: :xml
  end

  private

  def quote_params
    params.require(:quote).permit(:contact_name, :company_name, :email, :phone, :project_type, :budget, :message)
  end
end
