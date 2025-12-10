class DesignTemplatesController < ApplicationController
  def index
    @design_templates = DesignTemplate.all.order(created_at: :desc)
    # Seed 데이터가 없을 경우를 대비해 placeholder 로직은 View에서 처리하거나 Helper 사용
  end
end
