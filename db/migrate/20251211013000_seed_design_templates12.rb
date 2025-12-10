class SeedDesignTemplates12 < ActiveRecord::Migration[7.1]
  def up
    # 기존 데이터 삭제 (안전하게 초기화)
    DesignTemplate.destroy_all

    templates = [
      {
        title: "LUMIER",
        category: "Beauty & Salon",
        description: "청담동 하이엔드 살롱 스타일. 고급스러운 세리프 폰트와 인물 중심 레이아웃으로 브랜드의 품격을 높여줍니다. 뷰티, 헤어, 스파 브랜드에 최적화되어 있습니다.",
        price: 1500000,
        is_active: true,
        preview_url: "/templates/beauty"
      },
      {
        title: "溫 (ON)",
        category: "Dining & F&B",
        description: "여백의 미를 살린 모던 오마카세 다이닝 스타일. 갤러리 같은 메뉴 소개와 정갈한 레이아웃이 음식의 가치를 더합니다. 파인다이닝, 카페, 레스토랑에 적합합니다.",
        price: 1200000,
        is_active: true,
        preview_url: "/templates/dining"
      },
      {
        title: "Sculpt & Soul",
        category: "Fitness & Wellness",
        description: "아티스틱 웰니스 브랜드 스타일. 감각적인 다크 모드와 강렬한 타이포그래피가 역동적인 에너지를 전달합니다. 피트니스, 요가, 개인 PT 스튜디오에 추천합니다.",
        price: 1300000,
        is_active: true,
        preview_url: "/templates/gym"
      },
      {
        title: "Focus Lab",
        category: "Space & Rental",
        description: "건축적인 조형미가 돋보이는 스터디 랩 스타일. 벤토 그리드(Bento Grid) 레이아웃으로 정보를 체계적으로 전달합니다. 스터디카페, 독서실, 오피스 임대에 최적화되었습니다.",
        price: 1100000,
        is_active: true,
        preview_url: "/templates/study"
      },
      {
        title: "서촌 쉼",
        category: "Stay & Travel",
        description: "한옥의 정취를 담은 감성 스테이 스타일. 수평 스크롤과 여유로운공간감으로 힐링을 선사합니다. 펜션, 게스트하우스, 부티크 호텔에 어울립니다.",
        price: 1400000,
        is_active: true,
        preview_url: "/templates/stay"
      },
      {
        title: "Novus",
        category: "Corporate & Tech",
        description: "신뢰감을 주는 블루톤의 IT 스타트업 스타일. 직관적인 기능 소개와 SaaS형 구성으로 기술력을 강조합니다. 테크 기업, 솔루션 업체에 추천합니다.",
        price: 1800000,
        is_active: true,
        preview_url: "/templates/corporate"
      },
      {
        title: "AETHER",
        category: "E-commerce & Brand",
        description: "이미지가 돋보이는 모던 시크 패션 브랜드 스타일. 군더더기 없는 미니멀 UI로 상품 자체에 집중하게 합니다. 의류, 잡화, 쥬얼리 쇼핑몰에 적합합니다.",
        price: 2000000,
        is_active: true,
        preview_url: "/templates/ecommerce"
      },
      {
        title: "Daily Crumb",
        category: "Cafe & Bakery",
        description: "따뜻한 베이지톤의 감성 베이커리 스타일. 손으로 쓴 듯한 폰트와 부드러운 색감이 편안함을 줍니다. 카페, 베이커리, 디저트 샵에 어울립니다.",
        price: 1100000,
        is_active: true,
        preview_url: "/templates/cafe"
      },
      {
        title: "ARCHIVE",
        category: "Portfolio & Creative",
        description: "크리에이터를 위한 다크모드 그리드 갤러리. 작품을 돋보이게 하는 과감한 배치와 모션이 특징입니다. 디자이너, 포토그래퍼, 아티스트에게 추천합니다.",
        price: 900000,
        is_active: true,
        preview_url: "/templates/portfolio"
      },
      {
        title: "Pure Clinic",
        category: "Medical & Health",
        description: "깨끗하고 전문적인 느낌의 클리닉 스타일. 환자에게 신뢰를 주는 밝은 톤과 정보 중심의 레이아웃입니다. 치과, 피부과, 성형외과 등 병의원에 최적화되어 있습니다.",
        price: 1600000,
        is_active: true,
        preview_url: "/templates/medical"
      },
      {
        title: "Trust & Logic",
        category: "Professional & Law",
        description: "세리프 폰트와 네이비 컬러로 무게감을 준 전문직 스타일. 보수적이면서도 현대적인 세련미를 갖췄습니다. 법률사무소, 세무회계, 컨설팅 펌에 적합합니다.",
        price: 1700000,
        is_active: true,
        preview_url: "/templates/law"
      },
      {
        title: "Bliss Moment",
        category: "Wedding & Event",
        description: "파스텔 톤의 우아하고 로맨틱한 웨딩 페이지. 감성적인 타이포그래피와 부드러운 인터랙션이 특별한 날을 빛내줍니다. 청첩장, 웨딩홀, 이벤트 페이지로 좋습니다.",
        price: 800000,
        is_active: true,
        preview_url: "/templates/wedding"
      }
    ]

    templates.each do |data|
      DesignTemplate.create!(
        title: data[:title],
        category: data[:category],
        description: data[:description],
        price: data[:price],
        is_active: data[:is_active],
        preview_url: data[:preview_url]
      )
    end
  end

  def down
    DesignTemplate.destroy_all
  end
end
