class DesignTemplate < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_one_attached :pc_image
  has_one_attached :mobile_image
  
  has_many :cart_items, as: :item
  validates :title, presence: true

  # PC 대표 이미지 URL 반환
  def pc_thumbnail_url
    if pc_image.attached?
      begin
        url_for(pc_image)
      rescue
        image_url.presence || '/images/templates/portfolio_gallery.png'
      end
    else
      image_url.presence || '/images/templates/portfolio_gallery.png'
    end
  end

  # 모바일 대표 이미지 URL 반환
  def mobile_thumbnail_url
    if mobile_image.attached?
      begin
        url_for(mobile_image)
      rescue
        mobile_image_url.presence || pc_thumbnail_url
      end
    else
      mobile_image_url.presence || pc_thumbnail_url
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

  # Static data support for database-less architecture
  def self.all_static
    @static_data ||= YAML.load_file(Rails.root.join('config', 'templates.yml'))
    @static_data.map.with_index do |t, idx|
      OpenStruct.new(t).tap do |os|
        os.id = idx + 1
        os.pc_thumbnail_url = os.image_url.presence || '/images/templates/portfolio_gallery.png'
        os.mobile_thumbnail_url = os.mobile_image_url.presence || os.pc_thumbnail_url
      end
    end
  end
end
