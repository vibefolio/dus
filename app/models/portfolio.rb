class Portfolio < ApplicationRecord
  has_one_attached :image
  has_one_attached :mobile_image
  has_rich_text :description
  validates :title, presence: true

  # 카드에 쓸 이미지 하나를 고른다.
  #
  # 우선순위: 직접 올린 첨부 > 주 1회 자동 캡처 > 고객사 OG 핫링크
  # 자동 캡처가 실패한 건은 thumbnail_url 이 비어 있으므로 예전 image_url 로 그대로 폴백된다.
  # 셋 다 없으면 nil — 뷰가 플레이스홀더를 그린다.
  def card_image
    return image if image.attached?
    return thumbnail_url if thumbnail_url.present?
    image_url.presence
  end

  # 캡처본이 얼마나 신선한가. nil 이면 아직 한 번도 안 찍혔다는 뜻이다.
  def thumbnail_age_days
    return nil if thumbnail_captured_at.blank?
    ((Time.current - thumbnail_captured_at) / 1.day).floor
  end
end
