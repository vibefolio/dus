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
    image_url: "https://images.unsplash.com/photo-1527515653594-e0c6e001c408?q=80&w=800&auto=format&fit=crop",
    is_featured: false
  }
]

templates.each do |t|
  DesignTemplate.create!(t)
end

puts "Seed Data Created: #{DesignTemplate.count} Templates"
