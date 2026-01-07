class TemplatesController < ApplicationController
  # 템플릿 페이지는 기존 사이트의 헤더/푸터를 쓰지 않고 독립적인 디자인을 가집니다.
  layout "template_preview"

  # All templates in a list for reference (optional, but good for validation)
  VALID_TEMPLATES = %w[
    beauty dining gym study stay corporate ecommerce cafe portfolio 
    medical law wedding cleaning agency consulting academy sculpt yoga 
    nail barber flower burger wine salad dessert donut kinder startup 
    rental finance dental vet tax accounting camping studio petshop hotel pension 
    cloth shoe bag shopping learnhub english artistry
  ]

  def show
    template_name = params[:template_name]
    if VALID_TEMPLATES.include?(template_name)
      # Check if specific file exists (it should)
      if template_exists?(template_name)
        render template_name
      else
        # Fallback to file check if list is outdated
        render template_name
      end
    else
      redirect_to design_templates_path, alert: "템플릿을 찾을 수 없습니다."
    end
  rescue ActionView::MissingTemplate
    redirect_to design_templates_path, alert: "템플릿을 찾을 수 없습니다."
  end

  def sub_page
    template_name = params[:template_name]
    sub_page = params[:sub_page]

    # Try to render specific subpage if exists (e.g., templates/academy_instructor)
    specific_template = "#{template_name}_#{sub_page}"

    if template_exists?(specific_template)
      render specific_template
    else
      # Render generic subpage
      @template_name = template_name
      @sub_page_title = sub_page.humanize.titleize
      @theme = get_theme_data(template_name)
      render "templates/shared/generic_subpage"
    end
  end

  private

  def template_exists?(name)
    lookup_context.template_exists?(name, "templates", false)
  end

  def get_theme_data(template_name)
    # Basic mapping of themes.
    # In a real app, this might come from DB or config file.
    # Defaults
    {
      primary_color: '#333333',
      secondary_color: '#666666',
      font_family: 'sans-serif'
    }
  end
end
