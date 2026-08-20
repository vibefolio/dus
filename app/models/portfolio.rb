class Portfolio < ApplicationRecord
  has_one_attached :image
  has_one_attached :mobile_image
  has_rich_text :description
  validates :title, presence: true

  # 카드에 쓸 이미지 하나를 고른다.
  #
  # 우선순위: 직접 올린 첨부 > 사이트가 선언한 og:image > 손으로 박아둔 image_url
  # thumbnail_url 은 rake portfolio:sync_og 가 주 1회 각 사이트의 og:image 를 읽어 채운다.
  # OG 가 없거나 동기화가 실패한 건은 비어 있으므로 예전 image_url 로 그대로 폴백된다.
  # 셋 다 없으면 nil — 뷰가 플레이스홀더를 그린다.
  def card_image
    return image if image.attached?
    return thumbnail_url if thumbnail_url.present?
    image_url.presence
  end

  # og:image 를 마지막으로 확인한 지 얼마나 됐나. nil 이면 아직 한 번도 동기화 안 된 것이다.
  def thumbnail_age_days
    return nil if thumbnail_captured_at.blank?
    ((Time.current - thumbnail_captured_at) / 1.day).floor
  end
end
