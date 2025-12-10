# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Admin User
# User.create!(email: "admin@example.com", password: "password", password_confirmation: "password")

# Portfolio Samples
if Portfolio.count == 0
  Portfolio.create!([
    {
      title: "Fresh Grove",
      description: "유기농 음료 브랜드 Fresh Grove의 브랜드 웹사이트를 제작했습니다. 브랜드의 신선하고 건강한 이미지를 강조하기 위해 밝고 자연스러운 컬러 팔레트를 사용했으며, 제품 라인업을 매력적으로 보여주는 인터랙티브한 스크롤 경험을 구현했습니다. 모바일 최적화를 통해 언제 어디서나 제품 정보를 쉽게 확인할 수 있습니다.",
      category: "쇼핑몰",
      client: "Fresh Grove Inc.",
      project_date: "2024-11-15",
      image_url: "https://cdn.dribbble.com/userupload/16521743/file/original-a316235b6fc24806716075908f977c07.png?resize=1504x1128"
    },
    {
      title: "WISE",
      description: "오디오 기기 전문 브랜드 WISE의 이커머스 플랫폼입니다. 미니멀하고 세련된 디자인 언어를 적용하여 제품의 고급스러움을 강조했습니다. 사용자 리뷰, 기술 사양 비교 등 구매 결정에 필요한 정보를 직관적으로 배치하고, 간편한 결제 프로세스를 도입하여 구매 전환율을 높였습니다.",
      category: "쇼핑몰",
      client: "WISE Audio",
      project_date: "2024-10-20",
      image_url: "https://cdn.dribbble.com/userupload/15987158/file/original-6b58941031d200196881775f0a28392f.png?resize=1504x1128"
    },
    {
      title: "NOBASE CLASS",
      description: "IT 교육 플랫폼 NOBASE CLASS의 랜딩 페이지 및 수강 신청 사이트입니다. 타겟 오디언스인 입문자들에게 친근하게 다가가기 위해 부드러운 일러스트와 명확한 카피라이팅을 활용했습니다. 커리큘럼 로드맵을 시각화하여 학습 과정을 한눈에 파악할 수 있도록 디자인했습니다.",
      category: "웹사이트",
      client: "NOBASE Edu",
      project_date: "2024-09-05",
      image_url: "https://cdn.dribbble.com/userupload/14101235/file/original-b184c688c3a07804499696b9961239e3.png?resize=1200x900"
    },
    {
      title: "PICK",
      description: "인테리어 가구 큐레이션 서비스 PICK의 모바일 앱 디자인 및 개발 프로젝트입니다. 사용자의 취향을 분석하여 맞춤형 가구를 추천하는 AI 알고리즘을 탑재했습니다. 방대한 제품 이미지를 빠르게 로딩할 수 있도록 최적화했으며, '내 방에 미리보기' AR 기능을 구현하여 사용자 경험을 차별화했습니다.",
      category: "모바일 앱",
      client: "PICK Home",
      project_date: "2024-08-12",
      image_url: "https://cdn.dribbble.com/userupload/13010375/file/original-066160163351307b049968498f824e4d.png?resize=1200x900"
    }
  ])
end

# Design Template Samples (12개)
if defined?(DesignTemplate) && DesignTemplate.count == 0
  puts "Creating Design Templates..."
  templates = [
    { title: "Lumina Fashion", category: "쇼핑몰", description: "모던하고 미니멀한 패션 브랜드용 이커머스 템플릿입니다. 대형 이미지 배너와 깔끔한 그리드 레이아웃이 돋보입니다." },
    { title: "TechStarter", category: "기업/브랜드", description: "IT 스타트업을 위한 신뢰감 있는 코퍼레이트 사이트 디자인입니다. 서비스 소개와 팀원 소개 섹션이 강조되어 있습니다." },
    { title: "EcoLife", category: "쇼핑몰", description: "친환경 제품 판매에 최적화된 편안하고 따뜻한 느낌의 디자인입니다. 자연스러운 컬러톤과 유기적인 형태를 사용했습니다." },
    { title: "Portfolio Pro", category: "개인용", description: "크리에이터와 프리랜서를 위한 포트폴리오 전용 템플릿입니다. 작업물을 갤러리 형태로 효과적으로 보여줍니다." },
    { title: "Urban Cafe", category: "F&B", description: "트렌디한 카페나 레스토랑을 위한 감각적인 원페이지 사이트입니다. 메뉴 소개와 예약 기능이 포함되어 있습니다." },
    { title: "App Landing", category: "랜딩페이지", description: "모바일 앱 홍보를 위한 강력한 랜딩페이지입니다. 앱 스토어 다운로드 유도와 주요 기능 설명에 집중했습니다." },
    { title: "EduPlatform", category: "커뮤니티", description: "온라인 강의 및 교육 서비스를 위한 LMS 스타일 템플릿입니다. 강의 목차와 강사 소개, 수강 후기 섹션이 있습니다." },
    { title: "Medical Care", category: "기업/브랜드", description: "병원 및 의료기관을 위한 깨끗하고 전문적인 디자인입니다. 진료 안내와 의료진 프로필, 예약 문의 폼을 제공합니다." },
    { title: "Beauty Salon", category: "F&B", description: "뷰티 살롱, 네일샵 등을 위한 우아한 디자인입니다. 서비스 가격표와 인스타그램 연동 갤러리가 특징입니다." },
    { title: "Real Estate", category: "기업/브랜드", description: "부동산 중개 및 분양 서비스를 위한 템플릿입니다. 매물 검색 필터와 지도 연동 기능이 디자인되어 있습니다." },
    { title: "Travel Log", category: "블로그", description: "여행 작가나 블로거를 위한 매거진 스타일 템플릿입니다. 풍부한 사진과 텍스트를 조화롭게 배치할 수 있습니다." },
    { title: "Crypto Hub", category: "핀테크", description: "블록체인 및 암호화폐 관련 서비스를 위한 미래지향적인 다크모드 디자인입니다. 실시간 차트와 데이터 시각화가 돋보입니다." }
  ]

  templates.each do |t|
    DesignTemplate.create!(t)
    puts "Created template: #{t[:title]}"
  end
end
