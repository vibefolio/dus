class AddThumbnailToPortfolios < ActiveRecord::Migration[8.1]
  # 포트폴리오 카드에 쓰는 자동 캡처 썸네일.
  #
  # image_url 은 고객사 사이트의 OG 이미지를 직접 핫링크하고 있었는데,
  # 여러 건이 애초에 OG 가 아니라 사이트 내부 사진(공장 외관·포스터·갤러리)이라
  # 고객사가 사이트를 새로 만들어도 포트폴리오 썸네일은 영영 그대로였다.
  #
  # 그래서 preview_url 을 주 1회 직접 캡처해 버킷에 올리고 여기에 URL 을 적는다.
  # image_url 은 지우지 않는다 — 캡처가 실패하면 그대로 폴백으로 쓴다.
  def change
    add_column :portfolios, :thumbnail_url, :string
    add_column :portfolios, :thumbnail_captured_at, :datetime
  end
end
