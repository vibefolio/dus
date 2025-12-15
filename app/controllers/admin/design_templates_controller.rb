class Admin::DesignTemplatesController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_design_template, only: %i[ edit update destroy ]

  def index
    @design_templates = DesignTemplate.order(created_at: :desc)
  end

  def new
    @design_template = DesignTemplate.new
  end

  def create
    @design_template = DesignTemplate.new(design_template_params)

    if @design_template.save
      # PC 이미지 업로드 시 image_url 자동 업데이트
      update_image_urls(@design_template)
      
      Rails.cache.delete("featured_templates")
      redirect_to admin_design_templates_path, notice: "템플릿이 성공적으로 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @design_template.update(design_template_params)
      # PC/모바일 이미지 업로드 시 URL 자동 업데이트
      update_image_urls(@design_template)
      
      Rails.cache.delete("featured_templates")
      redirect_to admin_design_templates_path, notice: "템플릿이 성공적으로 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @design_template.destroy
    Rails.cache.delete("featured_templates")
    redirect_to admin_design_templates_path, notice: "템플릿이 삭제되었습니다."
  end

  private

  def set_design_template
    @design_template = DesignTemplate.find(params[:id])
  end

  def design_template_params
    params.require(:design_template).permit(
      :title, :description, :category, 
      :pc_image, :mobile_image, 
      :preview_url, :is_featured, 
      :image_url, :mobile_image_url
    )
  end

  # PC/모바일 이미지 업로드 시 URL 필드 자동 업데이트
  def update_image_urls(template)
    updates = {}
    
    # PC 이미지가 새로 업로드되었으면 image_url에 경로 저장
    if template.pc_image.attached? && template.pc_image.blob.created_at > 1.minute.ago
      updates[:image_url] = Rails.application.routes.url_helpers.rails_blob_path(template.pc_image, only_path: true)
    end
    
    # 모바일 이미지가 새로 업로드되었으면 mobile_image_url에 경로 저장
    if template.mobile_image.attached? && template.mobile_image.blob.created_at > 1.minute.ago
      updates[:mobile_image_url] = Rails.application.routes.url_helpers.rails_blob_path(template.mobile_image, only_path: true)
    end
    
    template.update_columns(updates) if updates.present?
  end
end
