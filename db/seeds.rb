# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data
puts "Clearing existing data..."
DesignTemplate.destroy_all

puts "Creating Design Templates..."

templates = [
  {
    title: "LUMIER | 뷰티 & 살롱",
    category: "뷰티/미용",
    description: "청담동 하이엔드 뷰티 살롱을 위한 프리미엄 템플릿입니다. 블랙&골드 컬러와 세리프 폰트를 사용하여 고급스러운 브랜드 이미지를 구축합니다. 아티스트 프로필과 시술 가격표, 예약 기능을 갖추고 있습니다.",
    preview_url: "/templates/beauty"
  },
  {
    title: "溫 (ON) | 모던 다이닝",
    category: "F&B/식당",
    description: "여백의 미를 살린 모던 한식 파인 다이닝 템플릿입니다. 계절감을 살린 메뉴 소개와 스토리텔링에 최적화되어 있으며, 갤러리 같은 레이아웃으로 음식 사진을 돋보이게 합니다.",
    preview_url: "/templates/dining"
  },
  {
    title: "Sculpt & Soul | 웰니스",
    category: "운동/헬스",
    description: "탬버린즈 스타일의 감각적인 프라이빗 짐 & 요가 스튜디오 템플릿입니다. 다크 모드와 강렬한 타이포그래피, 추상적인 비주얼로 단순한 운동 공간이 아닌 라이프스타일 브랜드로 포지셔닝합니다.",
    preview_url: "/templates/gym"
  },
  {
    title: "Focus Lab | 스터디",
    category: "교육/학원",
    description: "건축적인 그리드 시스템을 적용한 프리미엄 스터디 카페 템플릿입니다. 신뢰감을 주는 차분한 톤앤매너와 시설 정보를 명확하게 전달하는 UI로 이용객의 편의를 최우선으로 합니다.",
    preview_url: "/templates/study"
  },
  {
    title: "서촌 쉼 | 감성 스테이",
    category: "숙박/펜션",
    description: "한옥의 정취를 담은 감성 스테이 템플릿입니다. 가로 스크롤형 이미지 뷰어와 직관적인 예약 캘린더를 통해 방문객에게 여행의 설렘을 미리 전달합니다.",
    preview_url: "/templates/stay"
  }
]

templates.each do |t|
  DesignTemplate.create!(
    title: t[:title],
    category: t[:category],
    description: t[:description],
    preview_url: t[:preview_url]
  )
end

puts "Created #{DesignTemplate.count} design templates."
