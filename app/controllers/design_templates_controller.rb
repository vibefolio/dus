class DesignTemplatesController < ApplicationController
  def index
    begin
      @design_templates = DesignTemplate.all

      # Search functionality
      if params[:query].present?
        query = "%#{params[:query]}%"
        @design_templates = @design_templates.where(
          "title LIKE ? OR description LIKE ? OR category LIKE ?", 
          query, query, query
        )
      end

      # Category filter
      if params[:category].present? && params[:category] != 'all'
        @design_templates = @design_templates.where(category: params[:category])
      end

      # Sorting logic
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

      # Pagination (12 items per page)
      @design_templates = @design_templates.page(params[:page]).per(12).to_a
      
    rescue => e
      # DB 에러 발생 시 빈 배열로 설정 (Fallback 데이터가 뷰에서 사용됨)
      Rails.logger.error "DesignTemplate query failed: #{e.message}"
      @design_templates = []
    end
  end
end
