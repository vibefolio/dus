class DesignTemplate < ApplicationRecord
  has_one_attached :pc_image
  has_one_attached :mobile_image

  validates :title, presence: true

  # PC 대표 이미지 URL 반환 (순환 참조 방지를 위해 ActiveStorage Helper 제거)
  def pc_thumbnail_url
    image_url.presence || '/images/templates/portfolio_gallery.png'
  end

  # 모바일 대표 이미지 URL 반환
  def mobile_thumbnail_url
    mobile_image_url.presence || pc_thumbnail_url
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
