# Clear existing data
puts "Clearing existing data..."
Portfolio.destroy_all
Quote.destroy_all

# Create sample portfolios
puts "Creating sample portfolios..."

Portfolio.create!([
  {
    title: "디어스 공식 웹사이트",
    category: "웹사이트",
    client: "디어스",
    project_date: Date.new(2024, 12, 1),
    description: "AI 기반 개발 에이전시 디어스의 공식 웹사이트입니다. 모던한 디자인과 반응형 레이아웃으로 구현되었습니다.",
    image_url: "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800"
  },
  {
    title: "스마트 헬스케어 플랫폼",
    category: "웹 애플리케이션",
    client: "헬스케어 주식회사",
    project_date: Date.new(2024, 11, 15),
    description: "AI 기반 건강 관리 및 의료 상담 플랫폼입니다. 실시간 건강 데이터 분석 및 개인 맞춤형 건강 관리 서비스를 제공합니다.",
    image_url: "https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800"
  },
  {
    title: "푸드테크 배달 앱",
    category: "모바일 앱",
    client: "푸드테크 스타트업",
    project_date: Date.new(2024, 10, 20),
    description: "AI 추천 시스템을 활용한 음식 배달 모바일 앱입니다. iOS와 Android 플랫폼을 모두 지원합니다.",
    image_url: "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800"
  },
  {
    title: "이커머스 쇼핑몰",
    category: "웹 애플리케이션",
    client: "패션 브랜드 A",
    project_date: Date.new(2024, 9, 10),
    description: "프리미엄 패션 브랜드를 위한 이커머스 플랫폼입니다. 결제 시스템, 재고 관리, 회원 관리 등 통합 솔루션을 제공합니다.",
    image_url: "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800"
  },
  {
    title: "교육 플랫폼 UI/UX 리디자인",
    category: "UI/UX 디자인",
    client: "에듀테크 기업",
    project_date: Date.new(2024, 8, 5),
    description: "온라인 교육 플랫폼의 사용자 경험을 개선하기 위한 전면 리디자인 프로젝트입니다.",
    image_url: "https://images.unsplash.com/photo-1501504905252-473c47e087f8?w=800"
  },
  {
    title: "AI 챗봇 솔루션",
    category: "AI/ML",
    client: "금융 서비스 기업",
    project_date: Date.new(2024, 7, 1),
    description: "고객 상담을 위한 AI 챗봇 시스템입니다. 자연어 처리 기술을 활용하여 24/7 고객 지원을 제공합니다.",
    image_url: "https://images.unsplash.com/photo-1531746790731-6c087fecd65a?w=800"
  }
])

puts "Created #{Portfolio.count} portfolios"

# Create sample quotes
puts "Creating sample quotes..."

Quote.create!([
  {
    contact_name: "김철수",
    company_name: "테크 스타트업",
    email: "kim@techstartup.com",
    phone: "010-1234-5678",
    project_type: "웹 애플리케이션",
    budget: "1,000만원 ~ 3,000만원",
    message: "스타트업을 위한 SaaS 플랫폼 개발을 의뢰하고 싶습니다. 사용자 관리, 결제 시스템, 대시보드 등이 필요합니다.",
    status: "pending"
  },
  {
    contact_name: "이영희",
    company_name: "패션 브랜드 B",
    email: "lee@fashionb.com",
    phone: "010-2345-6789",
    project_type: "모바일 앱",
    budget: "3,000만원 ~ 5,000만원",
    message: "패션 브랜드를 위한 쇼핑 앱 개발을 원합니다. AR 기능을 통한 가상 피팅 기능이 포함되었으면 합니다.",
    status: "pending"
  },
  {
    contact_name: "박민수",
    company_name: "교육 서비스",
    email: "park@eduservice.com",
    phone: "010-3456-7890",
    project_type: "웹사이트 개발",
    budget: "500만원 ~ 1,000만원",
    message: "교육 기관 홈페이지 리뉴얼이 필요합니다. 반응형 디자인과 온라인 수강 신청 기능이 필요합니다.",
    status: "completed"
  }
])

puts "Created #{Quote.count} quotes"
puts "Seed data created successfully!"
