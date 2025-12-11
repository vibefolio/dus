# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding Design Templates..."

# 기존 데이터가 있으면 초기화 (중복 방지)
DesignTemplate.destroy_all

templates = [
  { 
    title: "LUMIER", 
    description: "청담동 하이엔드 살롱 스타일. 고급스러운 세리프 폰트와 인물 중심 레이아웃.", 
    category: "beauty", 
    preview_url: "/templates/beauty", 
    image_url: "https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=800&auto=format&fit=crop",
    is_featured: true 
  },
  { 
    title: "溫 (ON)", 
    description: "여백의 미를 살린 모던 오마카세 다이닝 스타일. 갤러리 같은 메뉴 소개 디자인.", 
    category: "dining", 
    preview_url: "/templates/dining", 
    image_url: "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800&auto=format&fit=crop",
    is_featured: true 
  },
  { 
    title: "Sculpt & Soul", 
    description: "아티스틱 웰니스 브랜드 스타일. 감각적인 다크 모드와 타이포그래피.", 
    category: "fitness", 
    preview_url: "/templates/gym", 
    image_url: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=800"
  },
  { 
    title: "Focus Lab", 
    description: "건축적인 조형미가 돋보이는 스터디 랩 스타일. 집중력을 높이는 미니멀리즘.", 
    category: "space", 
    preview_url: "/templates/study", 
    image_url: "https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=800"
  },
  { 
    title: "서촌 쉼", 
    description: "한옥의 정취를 담은 감성 스테이. 수평 스크롤 스토리텔링.", 
    category: "stay", 
    preview_url: "/templates/stay", 
    image_url: "https://images.unsplash.com/photo-1610641818989-c2051b5e2cfd?q=80&w=800",
    is_featured: true 
  },
  { 
    title: "AETHER", 
    description: "이미지가 돋보이는 모던 시크 패션 브랜드. 상품 디테일을 살리는 레이아웃.", 
    category: "shopping", 
    preview_url: "/templates/ecommerce", 
    image_url: "https://images.unsplash.com/photo-1445205170230-053b83016050?q=80&w=800"
  },
  { 
    title: "Novus", 
    description: "신뢰감을 주는 블루톤의 IT 스타트업 스타일. 데이터 시각화 섹션 포함.", 
    category: "corporate", 
    preview_url: "/templates/corporate", 
    image_url: "https://images.unsplash.com/photo-1551434678-e076c2236034?q=80&w=800"
  },
  { 
    title: "Daily Crumb", 
    description: "따뜻한 베이지톤의 감성 베이커리 스타일. 인스타그램 피드 연동 디자인.", 
    category: "cafe", 
    preview_url: "/templates/cafe", 
    image_url: "https://images.unsplash.com/photo-1549931319-a545dcf3bc73?q=80&w=800"
  },
  { 
    title: "ARCHIVE", 
    description: "크리에이터를 위한 다크모드 그리드 갤러리. 작품에만 집중할 수 있는 디자인.", 
    category: "portfolio", 
    preview_url: "/templates/portfolio", 
    image_url: "https://images.unsplash.com/photo-1600607686527-6fb886090705?q=80&w=800"
  },
  { 
    title: "Pure Clinic", 
    description: "깨끗하고 전문적인 느낌의 클리닉 스타일. 신뢰감을 주는 의료진 소개 섹션.", 
    category: "medical", 
    preview_url: "/templates/medical", 
    image_url: "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=800"
  },
  { 
    title: "Trust & Logic", 
    description: "세리프 폰트와 네이비 컬러로 무게감을 준 전문직. 성공 사례 중심 레이아웃.", 
    category: "law", 
    preview_url: "/templates/law", 
    image_url: "https://images.unsplash.com/photo-1589829085413-56de8ae18c73?q=80&w=800"
  },
  { 
    title: "Bliss", 
    description: "우아하고 로맨틱한 웨딩 플래너/베뉴 템플릿. 감성적인 비주얼 스토리텔링.", 
    category: "stay", 
    preview_url: "/templates/wedding", 
    image_url: "https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=800"
  },
  { 
    title: "클린 싹싹", 
    description: "건물위생관리업 정식 등록업체. 신뢰감을 주는 블루톤의 전문 청소업체 템플릿.", 
    category: "space", 
    preview_url: "/templates/cleaning", 
    image_url: "https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=800",
    is_featured: true
  },
  { 
    title: "Urban Fit", 
    description: "에너지 넘치는 현대적인 크로스핏/헬스장 템플릿. 강렬한 타이포그래피와 다이내믹한 레이아웃.", 
    category: "fitness", 
    preview_url: "/templates/gym", 
    image_url: "https://images.unsplash.com/photo-1540497077202-7c8a3999166f?q=80&w=800"
  },
  { 
    title: "Pet Palace", 
    description: "반려동물을 위한 프리미엄 케어 서비스. 부드러운 곡선과 따뜻한 파스텔톤 컬러.", 
    category: "shopping", 
    preview_url: "/templates/ecommerce", 
    image_url: "https://images.unsplash.com/photo-1548199973-03cce0bbc87b?q=80&w=800"
  },
  { 
    title: "Kids Station", 
    description: "아이들의 창의력을 자극하는 키즈카페. 알록달록한 컬러와 귀여운 일러스트 아이콘.", 
    category: "space", 
    preview_url: "/templates/cafe", 
    image_url: "https://images.unsplash.com/photo-1566737236500-c8ac43014a67?q=80&w=800"
  },
  { 
    title: "Camp Vibez", 
    description: "자연 속 힐링을 위한 감성 캠핑장. 예약 시스템 UI가 최적화된 아웃도어 스타일.", 
    category: "stay", 
    preview_url: "/templates/stay", 
    image_url: "https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?q=80&w=800"
  },
  { 
    title: "Flower & Garden", 
    description: "우아한 플로리스트 포트폴리오. 식물의 싱그러움을 담은 내추럴&보태니컬 디자인.", 
    category: "shopping", 
    preview_url: "/templates/beauty", 
    image_url: "https://images.unsplash.com/photo-1562690868-60bbe703395b?q=80&w=800"
  },
  { 
    title: "Burger House", 
    description: "힙한 수제버거 브랜드. 식욕을 자극하는 비비드한 컬러와 굵은 고딕 폰트.", 
    category: "dining", 
    preview_url: "/templates/dining", 
    image_url: "https://images.unsplash.com/photo-1586190848861-99c9574548e3?q=80&w=800"
  },
  { 
    title: "Wine Social", 
    description: "어두운 조명의 분위기 있는 와인바. 고급스러운 블랙 배경과 골드 포인트.", 
    category: "dining", 
    preview_url: "/templates/dining", 
    image_url: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?q=80&w=800"
  },
  { 
    title: "Sweet Spot", 
    description: "달콤한 디저트 카페. 여심을 저격하는 핑크빛 포인트와 부드러운 이미지.", 
    category: "cafe", 
    preview_url: "/templates/cafe", 
    image_url: "https://images.unsplash.com/photo-1551024506-0bccd828d307?q=80&w=800"
  },
  { 
    title: "Salad Green", 
    description: "건강한 샐러드 & 포케. 신선함을 강조하는 그린 컬러와 깨끗한 화이트 배경.", 
    category: "dining", 
    preview_url: "/templates/dining", 
    image_url: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=800"
  },
  { 
    title: "Code Academy", 
    description: "미래를 여는 코딩 교육. 테크니컬한 그리드와 아이소메트릭 일러스트 활용.", 
    category: "corporate", 
    preview_url: "/templates/corporate", 
    image_url: "https://images.unsplash.com/photo-1571171637578-41bc2dd41cd2?q=80&w=800"
  },
  { 
    title: "Piano Class", 
    description: "감성적인 피아노 학원. 클래식한 명조체와 우아한 분위기의 학원 소개.", 
    category: "corporate", 
    preview_url: "/templates/academy", 
    image_url: "https://images.unsplash.com/photo-1552422535-c45813c61732?q=80&w=800"
  },
  { 
    title: "English Kinder", 
    description: "글로벌 리더를 위한 영어 유치원. 밝고 활기찬 분위기의 교육 기관 템플릿.", 
    category: "corporate", 
    preview_url: "/templates/academy", 
    image_url: "https://images.unsplash.com/photo-1588072432836-e10032774350?q=80&w=800"
  },
  { 
    title: "Interior Pro", 
    description: "공간을 디자인하는 인테리어 시공. 시공 사례 전후 비교 슬라이더 제공.", 
    category: "portfolio", 
    preview_url: "/templates/portfolio", 
    image_url: "https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=800"
  },
  { 
    title: "Rent-All", 
    description: "쉽고 빠른 렌터카 예약. 직관적인 검색 바와 차량 상세 정보 카드.", 
    category: "corporate", 
    preview_url: "/templates/corporate", 
    image_url: "https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=800"
  },
  { 
    title: "Photo Studio", 
    description: "순간을 기록하는 사진관. 갤러리 형태의 레이아웃으로 사진에 집중.", 
    category: "portfolio", 
    preview_url: "/templates/portfolio", 
    image_url: "https://images.unsplash.com/photo-1554048612-387768052bf7?q=80&w=800"
  },
  { 
    title: "Tattoo Ink", 
    description: "개성을 새기는 타투샵. 강렬하고 힙한 분위기의 블랙&화이트 포트폴리오.", 
    category: "portfolio", 
    preview_url: "/templates/portfolio", 
    image_url: "https://images.unsplash.com/photo-1598371839696-5c5bb62d4067?q=80&w=800"
  },
  { 
    title: "Tax Pro", 
    description: "신뢰받는 세무 파트너. 전문적인 느낌의 네이비 컬러와 깔끔한 아이콘.", 
    category: "law", 
    preview_url: "/templates/law", 
    image_url: "https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?q=80&w=800"
  },
  { 
    title: "Build Arch", 
    description: "도시를 그리는 건축 사무소. 구조적인 레이아웃과 도면/조감도 갤러리.", 
    category: "corporate", 
    preview_url: "/templates/portfolio", 
    image_url: "https://images.unsplash.com/photo-1487958449943-2429e8be8625?q=80&w=800"
  },
  { 
    title: "Invest Future", 
    description: "성공적인 자산 관리 파트너. 신뢰를 주는 차분한 블루 그레이 톤.", 
    category: "corporate", 
    preview_url: "/templates/corporate", 
    image_url: "https://images.unsplash.com/photo-1579532537598-459ecdaf39cc?q=80&w=800"
  },
  { 
    title: "Logistics", 
    description: "글로벌 물류 운송 서비스. 역동적인 운송 이미지와 세계 지도 배경.", 
    category: "corporate", 
    preview_url: "/templates/corporate", 
    image_url: "https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?q=80&w=800"
  }
]

templates.each do |t|
  DesignTemplate.create!(t)
end

puts "Seed Data Created: #{DesignTemplate.count} Templates"
