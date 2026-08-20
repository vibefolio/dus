class AddThumbnailToPortfolios < ActiveRecord::Migration[8.1]
  # 포트폴리오 카드에 쓰는 자동 캡처 썸네일.
  #
  # image_url 은 고객사 사이트의 OG 이미지를 직접 핫링크하고 있었는데,
  # 여러 건이 애초에 OG 가 아니라 사이트 내부 사진(공장 외관·포스터·갤러리)이라
  # 고객사가 사이트를 새로 만들어도 포트폴리오 썸네일은 영영 그대로였다.
  #
  # 각 사이트는 <meta property="og:image"> 로 "우리 얼굴은 이것"이라고 이미 말하고 있다.
  # 주 1회 그걸 읽어 여기에 적는다 (rake portfolio:sync_og).
  # image_url 은 지우지 않는다 — OG 가 없거나 동기화가 실패하면 그대로 폴백으로 쓴다.
  def change
    add_column :portfolios, :thumbnail_url, :string
    add_column :portfolios, :thumbnail_captured_at, :datetime
  end
end
