class DesignTemplatesController < ApplicationController
  def index
    @design_templates = DesignTemplate.all

    # 정렬 로직
    case params[:sort]
    when 'popular'
      # view_count 컬럼이 있으면 사용, 없으면 오래된 순(임시)
      if DesignTemplate.column_names.include?('view_count')
        @design_templates = @design_templates.order(view_count: :desc)
      else
        @design_templates = @design_templates.order(created_at: :asc)
      end
    when 'latest'
      @design_templates = @design_templates.order(created_at: :desc)
    else # 'recommend' or default
      @design_templates = @design_templates.order(is_featured: :desc, created_at: :desc)
    end
  end
end
