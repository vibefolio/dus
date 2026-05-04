# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding Design Templates..."

# 템플릿 데이터 정의 (사용자 요청에 맞춘 한글 명칭 및 매칭)
templates = [
  { 
    title: "LUMIER 세미나", 
    description: "청담동 하이엔드 살롱 컨셉의 뷰티 브랜드 템플릿. 우아한 세리프와 그리드 레이아웃.", 
    category: "beauty", 
    preview_url: "/templates/beauty", 
    image_url: "https://images.unsplash.com/photo-1560750588-73207b1ef5b8?q=80&w=800",
    is_featured: true 
  },
  { 
    title: "溫 (ON) 다이닝", 
    description: "여백의 미를 살린 프리미엄 오마카세 다이닝. 고요하고 감각적인 디자인.", 
    category: "dining", 
    preview_url: "/templates/dining", 
    image_url: "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=800",
    is_featured: true 
  },
  { 
    title: "에테르노 필라테스", 
    description: "프리미엄 필라테스 스튜디오를 위한 슬릭하고 모던한 디자인. 내면의 균형을 강조.", 
    category: "fitness", 
    preview_url: "/templates/sculpt", 
    image_url: "https://images.unsplash.com/photo-1518310383802-640c2de311b2?q=80&w=800"
  },
  { 
    title: "요가 플로우", 
    description: "심플하고 차분한 무드. 요가 및 명상 센터를 위한 자연 친화적 템플릿.", 
    category: "fitness", 
    preview_url: "/templates/yoga", 
    image_url: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=800",
    is_featured: true
  },
  { 
    title: "라이브러리 원", 
    description: "프리미엄 스터디 라운지를 위한 세련된 다크 모드 디자인. 완벽한 몰입을 선사합니다.", 
    category: "space", 
    preview_url: "/templates/study", 
    image_url: "https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=800",
    is_featured: true
  },
  { 
    title: "리버사이드 스테이", 
    description: "감성 숙소와 독채 펜션을 위한 포트폴리오 스타일. 제주 등 여행지 컨셉.", 
    category: "stay", 
    preview_url: "/templates/stay", 
    image_url: "https://images.unsplash.com/photo-1584132967334-10e028bd69f7?q=80&w=800",
    is_featured: true 
  },
  { 
    title: "The Avenue", 
    description: "큐레이션이 돋보이는 패션 멀티샵. 브랜드 룩북 중심의 트렌디한 구성.", 
    category: "shopping", 
    preview_url: "/templates/shopping", 
    image_url: "https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=800",
    is_featured: true
  },
  { 
    title: "Novus 비즈니스", 
    description: "IT 스타트업 및 SaaS를 위한 올인원 협업 툴 컨셉의 메쉬 그라디언트 디자인.", 
    category: "corporate", 
    preview_url: "/templates/startup", 
    image_url: "https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=800"
  },
  { 
    title: "데일리 크럼", 
    description: "감성적인 무드의 베이커리. 정성 담긴 빵과 따뜻한 소통을 위한 카페 템플릿.", 
    category: "cafe", 
    preview_url: "/templates/cafe", 
    image_url: "https://images.unsplash.com/photo-1509440159596-0249088772ff?q=80&w=800",
    is_featured: true
  },
  { 
    title: "롤링도넛", 
    description: "팝한 컬러감과 폰트가 돋보이는 디저트 샵 전용 템플릿. 'Life is Sweet'.", 
    category: "cafe", 
    preview_url: "/templates/donut", 
    image_url: "https://images.unsplash.com/photo-1506152983158-b4a74a01c721?q=80&w=800",
    is_featured: true
  },
  { 
    title: "그린스 앤 그레인", 
    description: "가장 신선한 샐러드와 건강을 한 그릇에 담은 다목적 다이닝 템플릿.", 
    category: "dining", 
    preview_url: "/templates/salad", 
    image_url: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=800"
  },
  { 
    title: "에이전시X", 
    description: "디지털 혁신을 주도하는 크리에이티브 스튜디오 포트폴리오. 파격적인 무드.", 
    category: "portfolio", 
    preview_url: "/templates/agency", 
    image_url: "https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=800",
    is_featured: true
  },
  { 
    title: "미소라인 의원", 
    description: "신뢰감을 주는 화이트 톤의 메디컬 클리닉. 전문 의료진과 시술 정보를 한눈에.", 
    category: "medical", 
    preview_url: "/templates/medical", 
    image_url: "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=800",
    is_featured: true
  },
  { 
    title: "법무법인 정의", 
    description: "무게감 있는 전통적인 법률 전문가 그룹 템플릿. 신뢰와 권위를 강조.", 
    category: "law", 
    preview_url: "/templates/law", 
    image_url: "https://images.unsplash.com/photo-1589829545856-d10d557cf95f?q=80&w=800",
    is_featured: true
  },
  { 
    title: "그랜드 오션", 
    description: "바다가 보이는 프리미엄 호텔 템플릿. 시원한 레이아웃과 감성적인 무드.", 
    category: "stay", 
    preview_url: "/templates/hotel", 
    image_url: "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=800",
    is_featured: true
  },
  { 
    title: "클린싹싹", 
    description: "신뢰감을 주는 전문 청소 서비스 템플릿. 깔끔한 블루톤과 직관적인 서비스 소개.", 
    category: "space", 
    preview_url: "/templates/cleaning", 
    image_url: "https://images.unsplash.com/photo-1581578731548-c64695cc6952?q=80&w=800",
    is_featured: true
  },
  { 
    title: "와이즈 에셋", 
    description: "성공적인 자산을 위한 금융 파트너. 정제된 레이아웃과 안정감을 주는 디자인.", 
    category: "finance", 
    preview_url: "/templates/finance", 
    image_url: "https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=800",
    is_featured: true
  },
  { 
    title: "대치 엘리트", 
    description: "최고의 입시 및 코딩 교육 아카데미를 위한 클래식 세리프 디자인.", 
    category: "academy", 
    preview_url: "/templates/academy", 
    image_url: "https://images.unsplash.com/photo-1501504905252-473c47e087f8?q=80&w=800",
    is_featured: true
  },
  { 
    title: "MUA 진 치과", 
    description: "전문 의료진 정보와 차별화된 예약 시스템을 갖춘 현대적 치과 템플릿.", 
    category: "medical", 
    preview_url: "/templates/dental", 
    image_url: "https://images.unsplash.com/photo-1629909613654-28e377c37b09?q=80&w=800",
    is_featured: true
  },
  { 
    title: "위드 펫", 
    description: "반려동물을 위한 24시간 토탈 케어 솔루션. 따뜻하고 친근한 디자인.", 
    category: "medical", 
    preview_url: "/templates/vet", 
    image_url: "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?q=80&w=800",
    is_featured: true
  },
  { 
    title: "어반 킥스", 
    description: "스트릿 스니커즈 편집샵. 강렬한 대비와 역동적인 레이아웃의 쇼핑몰.", 
    category: "shopping", 
    preview_url: "/templates/shoe", 
    image_url: "https://images.unsplash.com/photo-1552346154-21d32810aba3?q=80&w=800",
    is_featured: true
  },
  { 
    title: "SKILLUP", 
    description: "내일의 성장을 위한 온라인 강의 플랫폼. 직관적인 카테고리 구성.", 
    category: "academy", 
    preview_url: "/templates/learnhub", 
    image_url: "https://images.unsplash.com/photo-1501504905252-473c47e087f8?q=80&w=800",
    is_featured: true
  },
  {
    title: "빈티지 1988",
    description: "열정과 시간이 빚어낸 고귀한 와인 컬렉션을 위한 럭셔리 템플릿.",
    category: "dining",
    preview_url: "/templates/wine",
    image_url: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?q=80&w=800",
    is_featured: true
  },

  # === Phase 2 추가 템플릿 (27~50) — 팬이지 업종 기반 ===

  {
    title: "인테리어 스튜디오",
    description: "감각적인 포트폴리오와 상담 예약이 결합된 인테리어 디자인 스튜디오 템플릿.",
    category: "portfolio",
    preview_url: "/templates/interior",
    image_url: "https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=800",
    is_featured: true,
    price: 390000
  },
  {
    title: "핸드폰 수리점",
    description: "즉시 수리, 가격 안내, 예약까지 한 번에. 스마트폰 수리 전문점을 위한 실용적 템플릿.",
    category: "space",
    preview_url: "/templates/shopping",
    image_url: "https://images.unsplash.com/photo-1601784551446-20c9e07cdbdb?q=80&w=800",
    is_featured: false,
    price: 290000
  },
  {
    title: "CPR 교육센터",
    description: "심폐소생술 및 응급처치 교육 기관을 위한 신뢰감 있는 안전 교육 플랫폼.",
    category: "academy",
    preview_url: "/templates/academy",
    image_url: "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=800",
    is_featured: false,
    price: 290000
  },
  {
    title: "공연·전시 기획",
    description: "갤러리, 독립 공연, 팝업 전시를 위한 감성적인 이벤트 에이전시 템플릿.",
    category: "portfolio",
    preview_url: "/templates/agency",
    image_url: "https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=800",
    is_featured: true,
    price: 390000
  },
  {
    title: "앱 개발사",
    description: "스타트업 및 IT 개발사를 위한 서비스 소개와 포트폴리오 중심 테크 템플릿.",
    category: "corporate",
    preview_url: "/templates/startup",
    image_url: "https://images.unsplash.com/photo-1555774698-0b77e0d5fac6?q=80&w=800",
    is_featured: true,
    price: 490000
  },
  {
    title: "코칭·멘토링",
    description: "커리어 코치, 라이프 코치를 위한 1:1 상담 및 프로그램 신청 특화 템플릿.",
    category: "academy",
    preview_url: "/templates/learnhub",
    image_url: "https://images.unsplash.com/photo-1531482615713-2afd69097998?q=80&w=800",
    is_featured: false,
    price: 290000
  },
  {
    title: "향원 한식당",
    description: "전통과 현대가 만나는 프리미엄 한식 다이닝. 코스 메뉴와 예약 중심의 고급 레스토랑 템플릿.",
    category: "dining",
    preview_url: "/templates/dining",
    image_url: "https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?q=80&w=800",
    is_featured: true,
    price: 390000
  },
  {
    title: "그로스 마케팅",
    description: "퍼포먼스 마케팅 에이전시를 위한 데이터 기반 성과 중심 비즈니스 템플릿.",
    category: "corporate",
    preview_url: "/templates/marketing-agency",
    image_url: "https://images.unsplash.com/photo-1533750349088-cd871a92f312?q=80&w=800",
    is_featured: false,
    price: 490000
  },
  {
    title: "마케팅 에이전시",
    description: "SNS·브랜딩·광고 전문 마케팅 에이전시의 포트폴리오와 서비스 소개 페이지.",
    category: "corporate",
    preview_url: "/templates/marketing-agency",
    image_url: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?q=80&w=800",
    is_featured: true,
    price: 490000
  },
  {
    title: "MZ 세대 브랜드",
    description: "Z세대 타겟 뷰티·패션 브랜드를 위한 숏폼 친화적이고 팝한 무드의 템플릿.",
    category: "shopping",
    preview_url: "/templates/mz",
    image_url: "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?q=80&w=800",
    is_featured: true,
    price: 390000
  },
  {
    title: "인쇄·굿즈 샵",
    description: "명함, 현수막, 스티커 등 소상공인 인쇄물을 전문으로 하는 B2B 인쇄소 템플릿.",
    category: "shopping",
    preview_url: "/templates/shopping",
    image_url: "https://images.unsplash.com/photo-1616628188540-925618b98318?q=80&w=800",
    is_featured: false,
    price: 290000
  },
  {
    title: "출판사·작가",
    description: "독립 출판사, 작가, 크리에이터를 위한 책 소개와 팬 커뮤니티 중심 포트폴리오.",
    category: "portfolio",
    preview_url: "/templates/portfolio",
    image_url: "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?q=80&w=800",
    is_featured: false,
    price: 290000
  },
  {
    title: "테크 스타트업",
    description: "B2B SaaS 및 기술 스타트업을 위한 기능 설명, 가격 플랜, 문의 폼이 갖춰진 랜딩페이지.",
    category: "corporate",
    preview_url: "/templates/startup",
    image_url: "https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=800",
    is_featured: true,
    price: 590000
  },
  {
    title: "올루올루 카페 (레트로)",
    description: "복고풍 색감과 레트로 타이포로 개성 넘치는 감성 카페 브랜딩 템플릿.",
    category: "cafe",
    preview_url: "/templates/cafe",
    image_url: "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=800",
    is_featured: true,
    price: 390000
  },
  {
    title: "부동산 중개",
    description: "매물 목록, 지도 연동, 상담 예약이 가능한 부동산 중개법인 전용 템플릿.",
    category: "space",
    preview_url: "/templates/realestate",
    image_url: "https://images.unsplash.com/photo-1560518883-ce09059eeffa?q=80&w=800",
    is_featured: true,
    price: 490000
  },
  {
    title: "헤어살롱",
    description: "포트폴리오와 예약이 결합된 트렌디한 헤어·네일 살롱 전용 템플릿.",
    category: "beauty",
    preview_url: "/templates/hair-salon",
    image_url: "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=800",
    is_featured: true,
    price: 390000
  },
  {
    title: "유기농 식료품점",
    description: "친환경·로컬 푸드를 판매하는 소규모 식료품점을 위한 따뜻하고 자연스러운 온라인 스토어.",
    category: "shopping",
    preview_url: "/templates/salad",
    image_url: "https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=800",
    is_featured: false,
    price: 290000
  },
  {
    title: "어린이집·유치원",
    description: "부모 신뢰를 얻는 따뜻한 톤의 보육시설 홈페이지. 커리큘럼·원장 소개·입소 안내 완비.",
    category: "academy",
    preview_url: "/templates/kinder",
    image_url: "https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?q=80&w=800",
    is_featured: true,
    price: 390000
  },
  {
    title: "자동차 정비소",
    description: "신뢰감을 주는 자동차 정비·튜닝샵을 위한 서비스 목록과 예약 중심 실용 템플릿.",
    category: "space",
    preview_url: "/templates/startup",
    image_url: "https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?q=80&w=800",
    is_featured: false,
    price: 290000
  },
  {
    title: "물류·배송 서비스",
    description: "중소 물류사, 퀵서비스, 화물 운송 기업을 위한 서비스 안내 및 견적 요청 페이지.",
    category: "corporate",
    preview_url: "/templates/corporate",
    image_url: "https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?q=80&w=800",
    is_featured: false,
    price: 290000
  },
  {
    title: "결혼식장·웨딩홀",
    description: "프리미엄 웨딩홀과 연회장을 위한 감성적인 웨딩 비즈니스 홈페이지 템플릿.",
    category: "stay",
    preview_url: "/templates/interior",
    image_url: "https://images.unsplash.com/photo-1519225421980-715cb0215aed?q=80&w=800",
    is_featured: true,
    price: 490000
  },
  {
    title: "보험 설계사",
    description: "고객 신뢰 구축을 위한 개인 보험 설계사 전용 전문가 브랜딩 페이지.",
    category: "finance",
    preview_url: "/templates/finance",
    image_url: "https://images.unsplash.com/photo-1450101499163-c8848c66ca85?q=80&w=800",
    is_featured: false,
    price: 390000
  },
  {
    title: "공인중개사 사무소",
    description: "개인 공인중개사를 위한 신뢰 기반 원룸·아파트 전문 중개 랜딩페이지.",
    category: "space",
    preview_url: "/templates/realestate",
    image_url: "https://images.unsplash.com/photo-1582407947304-fd86f028f716?q=80&w=800",
    is_featured: true,
    price: 390000
  }
]

# 기존 데이터 업데이트 및 카테고리 매칭 교정
templates.each do |t|
  template = DesignTemplate.find_or_initialize_by(preview_url: t[:preview_url])
  puts "Updating Template: #{t[:title]}"
  template.update!(
    title: t[:title],
    description: t[:description],
    category: t[:category],
    image_url: t[:image_url],
    is_featured: t[:is_featured] || false
  )
end

puts "Seed Data Updated Successfully: #{DesignTemplate.count} Templates"

# ============================================
# 포트폴리오 시드 데이터
# ============================================
puts "\nSeeding Portfolios..."

portfolios = [
  # === 앱 및 플랫폼 ===
  {
    title: "와요 (Wayo)",
    category: "앱 및 플랫폼",
    client: "계발자들 (Vibers)",
    project_date: Date.new(2026, 3, 1),
    description: "소중한 순간을 위한 AI 디지털 초대장 & 이벤트 플랫폼. Rails 8.1 API + Next.js 15 + Expo SDK 54 풀스택. AI 초대장 제작, RSVP 관리, QR 스캔 입장, 공연·전시 이벤트 탐색까지. 가보자고(gabojago) 서브도메인과 연동된 통합 이벤트 생태계.",
    image_url: "https://wayo.co.kr/og-image.png",
    preview_url: "https://wayo.co.kr"
  },
  {
    title: "제평가는요? (MyRatingIs)",
    category: "앱 및 플랫폼",
    client: "계발자들 (Vibers)",
    project_date: Date.new(2026, 2, 1),
    description: "흑백요리사 컨셉의 프로젝트·MVP 전문 평가 플랫폼. Next.js 14 + Supabase + Gemini Pro. 독창성·시장성·완성도 등 6개 지표 평가, 전문가 피드백, AI 분석 리포트 자동 생성. 전문평가위원 50명 × 창작자 50명 양면 플랫폼 구조.",
    image_url: "https://myratingis.kr/og-image.png",
    preview_url: "https://myratingis.kr"
  },
  {
    title: "프리미엄페이지 (PremiumPage)",
    category: "앱 및 플랫폼",
    client: "계발자들 (Vibers)",
    project_date: Date.new(2026, 1, 1),
    description: "기업 홈페이지를 인터랙티브 전자카탈로그로 변환하는 에이전시 플랫폼. Next.js 16 + React 19 + Prisma + SQLite. 23개 전문 템플릿, 다단계 견적 시스템, 최대 3개 템플릿 동시 비교, 라이브 프리뷰. HS-TECH·GENTOP·EMT 등 실제 기업 전자카탈로그 납품.",
    image_url: "https://premiumpage.kr/opengraph-image?acdee0525e5dba29",
    preview_url: "https://premiumpage.kr"
  },
  {
    title: "모노페이지 (Monopage)",
    category: "앱 및 플랫폼",
    client: "계발자들 (Vibers)",
    project_date: Date.new(2025, 11, 1),
    description: "나를 위한 단 하나의 링크 — 개인 프로필·링크·소개를 하나의 URL로 완성하는 단일 페이지 빌더. Next.js 16 + React 19 + Tailwind CSS 4. 동적 OG 이미지 생성, 외부 URL 메타 크롤링, 완전 반응형. Linktree 대체 솔루션.",
    image_url: "https://monopage.kr/og-image.png",
    preview_url: "https://monopage.kr"
  },
  {
    title: "바이브폴리오 (Vibefolio)",
    category: "앱 및 플랫폼",
    client: "계발자들 (Vibers)",
    project_date: Date.new(2025, 10, 1),
    description: "크리에이터·디자이너를 위한 AI 포트폴리오 아카이빙 & 레퍼런스 공유 플랫폼. Next.js 14 + Supabase + Tailwind. Masonry 그리드 피드, AI 자동 분석·썸네일 생성, 채용담당자 매칭, Pro 플랜(₩4,900/월) 수익 모델. Behance 스타일 국내 특화 플랫폼.",
    image_url: "https://vibefolio.net/og-image.png",
    preview_url: "https://vibefolio.net"
  },
  {
    title: "야화 (YAHWA)",
    category: "웹사이트",
    client: "야화 프랜차이즈",
    project_date: Date.new(2026, 3, 1),
    description: "프리미엄 시그니처 칵테일 혼술바 프랜차이즈 마케팅 사이트. 네이버 지도 매장 연동, Recharts 기반 수익 시뮬레이션 차트, 인스타그램 피드 자동 연동, FAQ 스키마 마크업 등 SEO 최적화 풀패키지. 80% 마진율·3개월 BEP 강조 전환율 최적화 설계.",
    image_url: "https://yahwabar.com/yahwa/images/ogbg.png",
    preview_url: "https://yahwabar.com"
  },
]

portfolios.each do |p|
  portfolio = Portfolio.find_or_initialize_by(title: p[:title])
  puts "#{portfolio.new_record? ? 'Creating' : 'Updating'} Portfolio: #{p[:title]}"
  portfolio.update!(
    category: p[:category],
    client: p[:client],
    project_date: p[:project_date],
    image_url: p[:image_url],
    preview_url: p[:preview_url]
  )
  # description은 ActionText (has_rich_text)이므로 별도 할당
  portfolio.update!(description: p[:description]) if portfolio.description.blank? || portfolio.description.to_plain_text != p[:description]
end

puts "Portfolio Seed Complete: #{Portfolio.count} Portfolios"

# ──────────────────────────────────────────────
# 협업 포트폴리오
# ──────────────────────────────────────────────
puts "\nSeeding Collaboration Portfolios..."

collab_portfolios = [
  # 디어스 × 프리미엄페이지 — 전자카탈로그
  {
    title: "항성산업사",
    category: "협업",
    sub_category: "전자카탈로그",
    collab_partner: "프리미엄페이지",
    client: "항성산업사",
    project_date: Date.new(2025, 6, 1),
    description: "산업용 제품 전문 기업 항성산업사의 인터랙티브 전자카탈로그. 프리미엄페이지 플랫폼 기반 제작.",
    image_url: "https://premiumpage.kr/templates/hangseong/opengraph-image.png",
    preview_url: "https://hangseong.premiumpage.kr"
  },
  {
    title: "젠탑 (GENTOP)",
    category: "협업",
    sub_category: "전자카탈로그",
    collab_partner: "프리미엄페이지",
    client: "젠탑",
    project_date: Date.new(2025, 7, 1),
    description: "GENTOP 제품 라인업을 담은 고품질 전자카탈로그. 프리미엄페이지 플랫폼 기반 제작.",
    image_url: "https://gentop.premiumpage.kr/images/home/hero-bg.png",
    preview_url: "https://gentop.premiumpage.kr"
  },
  {
    title: "HS TECH CO.",
    category: "협업",
    sub_category: "전자카탈로그",
    collab_partner: "프리미엄페이지",
    client: "HS Tech Co.",
    project_date: Date.new(2025, 8, 1),
    description: "HS Tech Co.의 기술 제품군 전자카탈로그. 프리미엄페이지 플랫폼 기반 제작.",
    image_url: "https://premiumpage.kr/templates/air-hstech/images/hero-1.jpg",
    preview_url: "https://hstechco.premiumpage.kr"
  },
  {
    title: "HS TECH",
    category: "협업",
    sub_category: "전자카탈로그",
    collab_partner: "프리미엄페이지",
    client: "HS Tech",
    project_date: Date.new(2025, 9, 1),
    description: "HS Tech 제품 전자카탈로그. 프리미엄페이지 플랫폼 기반 제작.",
    image_url: "https://premiumpage.kr/opengraph-image?acdee0525e5dba29",
    preview_url: "https://hstech.premiumpage.kr"
  },
  {
    title: "EMT",
    category: "협업",
    sub_category: "전자카탈로그",
    collab_partner: "프리미엄페이지",
    client: "EMT",
    project_date: Date.new(2025, 10, 1),
    description: "EMT 산업 장비 전자카탈로그. 프리미엄페이지 플랫폼 기반 제작.",
    image_url: "https://premiumpage.kr/og/emt.png",
    preview_url: "https://emt.premiumpage.kr"
  },
  # 디어스 × 팬이지 — 웹사이트
  {
    title: "올루올루 (OLUOLU)",
    category: "협업",
    sub_category: "웹사이트",
    collab_partner: "팬이지",
    client: "올루올루",
    project_date: Date.new(2026, 2, 1),
    description: "NO.1 프리미엄 아사이볼 & 그릭요거트 브랜드의 메인 마케팅 사이트 + 프랜차이즈 모집 랜딩페이지. 인스타그램 피드 연동, 매장 찾기, 메뉴 슬라이더, 문의 폼 등 6개 페이지 변형 제작. MZ세대 타겟 레트로/프리미엄 디자인 시스템 구축.",
    image_url: "https://oluolu.co.kr/oluolu/og-oluolu.png",
    preview_url: "https://oluolu.co.kr"
  },
  {
    title: "비즈온 마케팅 (BIZON)",
    category: "협업",
    sub_category: "웹사이트",
    collab_partner: "팬이지",
    client: "비즈온 마케팅",
    project_date: Date.new(2026, 1, 15),
    description: "프랜차이즈 & 자영업 마케팅 컨설팅 에이전시 브랜드 사이트. 스냅 스크롤 기반 풀페이지 인터랙션, 커스텀 타이포그래피(Paperlogy), 실시간 문의 시스템 연동. V1→V5까지 5번의 디자인 이터레이션을 거쳐 전환율 극대화.",
    image_url: "https://bizonmarketing.co.kr/bizon/og-bizon.png",
    preview_url: "https://bizonmarketing.co.kr"
  },
  {
    title: "CPR 마케팅",
    category: "협업",
    sub_category: "웹사이트",
    collab_partner: "팬이지",
    client: "CPR 마케팅",
    project_date: Date.new(2026, 2, 15),
    description: "부산 지역 맛집 네이버 플레이스 최적화 전문 마케팅 에이전시 사이트. 12개+ 실제 클라이언트 성과 Before/After 포트폴리오, 동적 배경 이미지(Pexels/Unsplash API), A/B 테스트용 2가지 디자인 변형 제작. 자영업자 출신 대표의 진정성을 살린 스토리텔링 기반 설계.",
    image_url: "https://cprmarketing.co.kr/cpr/og-cpr.png",
    preview_url: "https://cprmarketing.co.kr"
  },
  {
    title: "보이는마케팅",
    category: "협업",
    sub_category: "웹사이트",
    collab_partner: "팬이지",
    client: "보이는마케팅",
    project_date: Date.new(2026, 4, 1),
    description: "검색 최적화 마케팅 컨설팅 브랜드 사이트. Framer Motion 기반 3D 돋보기 히어로 인터랙션, 방문자 +340% 증가 등 실제 성과 데이터 시각화, 고급 스크롤 애니메이션. 전환율 중심의 원페이지 랜딩 설계.",
    image_url: "https://boineun.faneasy.kr/boineun/og-boineun.png",
    preview_url: "https://boineun.faneasy.kr"
  },
  {
    title: "세모폰 (Semophone)",
    category: "협업",
    sub_category: "웹사이트",
    collab_partner: "팬이지",
    client: "세모폰",
    project_date: Date.new(2026, 3, 1),
    description: "팬이지 기반으로 제작된 세모폰 브랜드 사이트.",
    image_url: "https://semophone.co.kr/og-image.png",
    preview_url: "https://semophone.co.kr"
  },
  {
    title: "셰프브릿지",
    category: "협업",
    sub_category: "웹사이트",
    collab_partner: "팬이지",
    client: "셰프브릿지",
    project_date: Date.new(2026, 4, 1),
    description: "팬이지 기반으로 제작된 셰프브릿지 브랜드 사이트.",
    image_url: "https://chefbridge.co.kr/chefbridge/og-chefbridge.png",
    preview_url: "https://chefbridge.co.kr"
  },
  {
    title: "작당페스타",
    category: "협업",
    sub_category: "웹사이트",
    collab_partner: "팬이지",
    client: "작당페스타",
    project_date: Date.new(2026, 4, 1),
    description: "크리에이터·팬·브랜드를 잇는 페스타 이벤트 플랫폼. 팬이지 기반으로 제작된 행사 홈페이지.",
    image_url: "https://xn--ok1b401abvd0pl7qd.kr/jakdangfesta/poster1.jpg",
    preview_url: "https://작당페스타.kr"
  },
]

collab_portfolios.each do |p|
  portfolio = Portfolio.find_or_initialize_by(title: p[:title])
  puts "#{portfolio.new_record? ? 'Creating' : 'Updating'} Collab Portfolio: #{p[:collab_partner]} × #{p[:title]}"
  portfolio.update!(
    category:      p[:category],
    sub_category:  p[:sub_category],
    collab_partner: p[:collab_partner],
    client:        p[:client],
    project_date:  p[:project_date],
    image_url:     p[:image_url],
    preview_url:   p[:preview_url]
  )
  portfolio.update!(description: p[:description]) if portfolio.description.blank? || portfolio.description.to_plain_text != p[:description]
end

puts "Collaboration Portfolio Seed Complete: #{Portfolio.where(category: '협업').count} collab portfolios"
