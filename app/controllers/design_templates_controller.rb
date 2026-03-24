class DesignTemplatesController < ApplicationController
  PER_PAGE = 12

  def index
    begin
      page = [params[:page].to_i, 1].max

      # DB 템플릿을 먼저 쿼리 레벨에서 필터링
      db_scope = DesignTemplate.all

      if params[:query].present?
        query = "%#{params[:query].downcase}%"
        db_scope = db_scope.where(
          "LOWER(title) LIKE :q OR LOWER(description) LIKE :q OR LOWER(category) LIKE :q", q: query
        )
      end

      if params[:category].present? && params[:category] != "all"
        db_scope = db_scope.where(category: params[:category])
      end

      case params[:sort]
      when "popular"
        db_scope = db_scope.order(Arel.sql("CASE WHEN is_featured THEN 0 ELSE 1 END, title"))
      when "latest"
        db_scope = db_scope.order(id: :desc)
      else
        db_scope = db_scope.order(Arel.sql("CASE WHEN is_featured THEN 0 ELSE 1 END"))
      end

      db_total = db_scope.count

      # 정적 템플릿 로드 및 필터링 (DB 결과가 페이지를 채우지 못할 때만)
      static_templates = []
      db_pages = (db_total.to_f / PER_PAGE).ceil

      if page > db_pages || db_total < PER_PAGE
        static_templates = DesignTemplate.static_templates rescue []

        if params[:query].present?
          query = params[:query].downcase
          static_templates = static_templates.select do |t|
            t.title.downcase.include?(query) ||
            t.description.downcase.include?(query) ||
            t.category.downcase.include?(query)
          end
        end

        if params[:category].present? && params[:category] != "all"
          static_templates = static_templates.select { |t| t.category == params[:category] }
        end

        case params[:sort]
        when "popular"
          static_templates = static_templates.sort_by { |t| [t.is_featured ? 0 : 1, t.title] }
        when "latest"
          static_templates = static_templates.reverse
        else
          static_templates = static_templates.sort_by { |t| t.is_featured ? 0 : 1 }
        end
      end

      # DB 결과와 정적 템플릿을 합쳐서 페이지네이션
      # NOTE: DB 템플릿이 충분할 경우 정적 템플릿은 로드하지 않음 (성능 최적화)
      all_templates = db_scope.to_a + static_templates
      @design_templates = Kaminari.paginate_array(all_templates).page(page).per(PER_PAGE)

    rescue => e
      Rails.logger.error "Template load failed: #{e.message}"
      @design_templates = []
    end
  end
end
