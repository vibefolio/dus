class DesignTemplate < ApplicationRecord
  has_one_attached :pc_image
  has_one_attached :mobile_image

  validates :title, presence: true

  # PC 대표 이미지 URL 반환 (우선순위: 업로드된 파일 > image_url)
  def pc_thumbnail_url
    if pc_image.attached?
      Rails.application.routes.url_helpers.rails_blob_path(pc_image, only_path: true)
    elsif image_url.present?
      image_url
    else
      nil
    end
  end

  # 모바일 대표 이미지 URL 반환 (우선순위: 업로드된 파일 > mobile_image_url > PC 이미지)
  def mobile_thumbnail_url
    if mobile_image.attached?
      Rails.application.routes.url_helpers.rails_blob_path(mobile_image, only_path: true)
    elsif mobile_image_url.present?
      mobile_image_url
    else
      pc_thumbnail_url # 모바일 이미지가 없으면 PC 이미지 사용
    end
  end

  # 현재 적용된 PC 이미지 소스 타입 반환
  def pc_image_source_type
    if pc_image.attached?
      :uploaded
    elsif image_url.present?
      :url
    else
      :none
    end
  end

  # 현재 적용된 모바일 이미지 소스 타입 반환
  def mobile_image_source_type
    if mobile_image.attached?
      :uploaded
    elsif mobile_image_url.present?
      :url
    else
      :none
    end
  end
end
