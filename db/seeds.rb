# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data
puts "Clearing existing data..."
DesignTemplate.destroy_all

puts "Creating Design Templates..."

templates = [
  # 1. 뷰티 (LUMIER)
  {
    title: "LUMIER | 뷰티 & 살롱",
    category: "뷰티/미용",
    description: "청담동 하이엔드 뷰티 살롱을 위한 프리미엄 템플릿입니다. 블랙&골드 컬러와 세리프 폰트를 사용하여 고급스러운 브랜드 이미지를 구축합니다.",
    preview_url: "/templates/beauty"
  },
  # 2. 다이닝 (ON)
  {
    title: "溫 (ON) | 모던 다이닝",
    category: "F&B/식당",
    description: "여백의 미를 살린 모던 한식 파인 다이닝 템플릿입니다. 갤러리 같은 레이아웃으로 음식 사진을 돋보이게 합니다.",
    preview_url: "/templates/dining"
  },
  # 3. 짐 (Sculpt & Soul)
  {
    title: "Sculpt & Soul | 웰니스",
    category: "운동/헬스",
    description: "탬버린즈 스타일의 감각적인 프라이빗 짐 & 요가 스튜디오 템플릿입니다. 다크 모드와 강렬한 타이포그래피가 특징입니다.",
    preview_url: "/templates/gym"
  },
  # 4. 스터디 (Focus Lab)
  {
    title: "Focus Lab | 스터디",
    category: "교육/학원",
    description: "건축적인 그리드 시스템을 적용한 프리미엄 스터디 카페 템플릿입니다. 신뢰감을 주는 차분한 톤앤매너가 인상적입니다.",
    preview_url: "/templates/study"
  },
  # 5. 스테이 (서촌 쉼)
  {
    title: "서촌 쉼 | 감성 스테이",
    category: "숙박/펜션",
    description: "한옥의 정취를 담은 감성 스테이 템플릿입니다. 가로 스크롤형 이미지 뷰어로 공간의 아름다움을 전달합니다.",
    preview_url: "/templates/stay"
  },
  # 6. 기업 (Novus)
  {
    title: "Novus | IT 솔루션",
    category: "기업/스타트업",
    description: "신뢰감을 주는 블루톤의 IT 스타트업 스타일. 직관적인 기능 소개와 SaaS형 구성으로 기술력을 강조합니다.",
    preview_url: "/templates/corporate"
  },
  # 7. 쇼핑몰 (AETHER)
  {
    title: "AETHER | 브랜드몰",
    category: "쇼핑몰/패션",
    description: "이미지가 돋보이는 모던 시크 패션 브랜드 스타일. 군더더기 없는 미니멀 UI로 상품 자체에 집중하게 합니다.",
    preview_url: "/templates/ecommerce"
  },
  # 8. 카페 (Daily Crumb)
  {
    title: "Daily Crumb | 베이커리",
    category: "카페/식음료",
    description: "따뜻한 베이지톤의 감성 베이커리 스타일. 손으로 쓴 듯한 폰트와 부드러운 색감이 편안함을 줍니다.",
    preview_url: "/templates/cafe"
  },
  # 9. 포트폴리오 (ARCHIVE)
  {
    title: "ARCHIVE | 포트폴리오",
    category: "개인/프리랜서",
    description: "크리에이터를 위한 다크모드 그리드 갤러리. 작품을 돋보이게 하는 과감한 배치와 모션이 특징입니다.",
    preview_url: "/templates/portfolio"
  },
  # 10. 병원 (Pure Clinic)
  {
    title: "Pure Clinic | 병원",
    category: "병원/의료",
    description: "깨끗하고 전문적인 느낌의 클리닉 스타일. 환자에게 신뢰를 주는 밝은 톤과 정보 중심의 레이아웃입니다.",
    preview_url: "/templates/medical"
  },
  # 11. 법률 (Trust & Logic)
  {
    title: "Trust & Logic | 법무",
    category: "법률/전문직",
    description: "세리프 폰트와 네이비 컬러로 무게감을 준 전문직 스타일. 보수적이면서도 현대적인 세련미를 갖췄습니다.",
    preview_url: "/templates/law"
  },
  # 12. 웨딩 (Bliss)
  {
    title: "Bliss | 웨딩 & 이벤트",
    category: "웨딩/청첩장",
    description: "파스텔 톤의 우아하고 로맨틱한 웨딩 페이지. 감성적인 타이포그래피와 부드러운 인터랙션이 특별한 날을 빛내줍니다.",
    preview_url: "/templates/wedding"
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
