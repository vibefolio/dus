# 디어스 (D.US) - 공식 웹사이트

AI와 함께하는 디지털 혁신 파트너, 디어스의 공식 웹사이트입니다.

## 🎨 주요 기능

### 공개 페이지

- **메인 페이지** - 회사 소개, 서비스 안내, 주요 성과 지표
- **디자인 템플릿** - 33종의 다양한 템플릿 쇼케이스
  - 🔍 실시간 검색 기능
  - 🏷️ 카테고리 필터링
  - 📊 정렬 기능 (추천순/인기순/최신순)
  - 📄 페이지네이션 (12개씩)
- **포트폴리오** - 완성된 프로젝트 쇼케이스
- **문의하기** - 프로젝트 견적 문의 폼
  - 📧 자동 이메일 알림 (관리자 + 고객)

### 관리자 페이지

- **대시보드** - 통계 및 최근 활동
- **포트폴리오 관리** - CRUD 기능으로 프로젝트 관리
- **템플릿 관리** - 디자인 템플릿 CRUD
- **문의 내역 관리** - 고객 문의 확인 및 관리
- **견적서 PDF 생성** - 프로페셔널한 견적서 자동 생성

## 🚀 기술 스택

- **Backend**: Ruby on Rails 8.1
- **Database**: SQLite3 (dev), PostgreSQL (production)
- **Frontend**: HTML5, Tailwind CSS
- **PDF Generation**: Prawn
- **Authentication**: Session-based
- **Email**: ActionMailer
- **Pagination**: Kaminari
- **Security**: Rack Attack (Rate Limiting)
- **Performance**: Rails Cache, Bullet (N+1 detection)

## 📦 설치 및 실행

### 1. 저장소 클론

```bash
git clone <repository-url>
cd dlab-website
```

### 2. 의존성 설치

```bash
bundle install
```

### 3. 데이터베이스 설정

```bash
rails db:create
rails db:migrate
rails db:seed  # 샘플 데이터 (선택사항)
```

### 4. 서버 실행

```bash
rails server
```

웹사이트가 `http://localhost:3000`에서 실행됩니다.

## 🔐 관리자 접근

관리자 페이지 접근 시 인증이 필요합니다:

- **URL**: `http://localhost:3000/admin/portfolios` 또는 `http://localhost:3000/admin/quotes`
- **기본 계정**:
  - Username: `admin`
  - Password: `password123`

### 환경 변수로 계정 변경

`.env` 파일을 생성하고 다음 내용을 추가하세요:

```env
ADMIN_USERNAME=your_username
ADMIN_PASSWORD=your_secure_password
```

## 📁 프로젝트 구조

```
app/
├── controllers/
│   ├── admin/              # 관리자 컨트롤러
│   │   ├── portfolios_controller.rb
│   │   └── quotes_controller.rb
│   └── pages_controller.rb # 공개 페이지 컨트롤러
├── models/
│   ├── portfolio.rb        # 포트폴리오 모델
│   └── quote.rb            # 견적 문의 모델
├── views/
│   ├── admin/              # 관리자 뷰
│   ├── layouts/
│   │   ├── application.html.erb  # 공개 레이아웃
│   │   └── admin.html.erb         # 관리자 레이아웃
│   └── pages/              # 공개 페이지 뷰
├── services/
│   └── quote_pdf_generator.rb  # PDF 생성 서비스
└── assets/
    └── stylesheets/
        └── application.css # 메인 스타일시트
```

## 🎨 디자인 시스템

### 컬러 팔레트

- **Primary**: `#00A859` (Green)
- **Accent**: `#00D670` (Light Green)
- **Gray Scale**: `#F9FAFB` ~ `#111827`

### 타이포그래피

- **Display Font**: Outfit
- **Body Font**: Inter

### 주요 컴포넌트

- Buttons (Primary, Accent, Outline)
- Cards (with hover effects)
- Forms (with validation styling)
- Navigation (fixed with scroll effects)

## 📝 주요 페이지

### 공개 페이지

- `/` - 메인 페이지
- `/portfolio` - 포트폴리오
- `/contact` - 문의하기

### 관리자 페이지

- `/admin/portfolios` - 포트폴리오 관리
- `/admin/portfolios/new` - 새 포트폴리오 등록
- `/admin/portfolios/:id/edit` - 포트폴리오 수정
- `/admin/quotes` - 문의 내역
- `/admin/quotes/:id` - 문의 상세
- `/admin/quotes/:id/generate_pdf` - PDF 생성

## 🔧 개발 가이드

### 새로운 포트폴리오 추가

1. 관리자 페이지 로그인
2. "포트폴리오 관리" 메뉴 선택
3. "새 포트폴리오 추가" 버튼 클릭
4. 필수 정보 입력:
   - 프로젝트명 (필수)
   - 카테고리
   - 클라이언트
   - 프로젝트 날짜
   - 이미지 URL
   - 프로젝트 설명

### 견적서 PDF 생성

1. 관리자 페이지에서 문의 내역 확인
2. 상세 페이지에서 "견적서 PDF 생성" 버튼 클릭
3. PDF 파일 자동 다운로드

## 🚢 배포

### 환경 변수 설정

프로덕션 환경에서는 다음 환경 변수를 설정하세요:

```env
RAILS_ENV=production
SECRET_KEY_BASE=<your-secret-key>
ADMIN_USERNAME=<secure-username>
ADMIN_PASSWORD=<secure-password>
```

### 데이터베이스 마이그레이션

```bash
RAILS_ENV=production rails db:migrate
```

### 에셋 프리컴파일

```bash
RAILS_ENV=production rails assets:precompile
```

## 📄 라이선스

Copyright © 2025 디어스 (D.US). All rights reserved.

## 🤝 기여

이 프로젝트는 디어스 내부 프로젝트입니다.

## 📞 문의

- 이메일: contact@dlab.kr
- 전화: 02-1234-5678
- 웹사이트: https://dlab.kr

---

Made with ❤️ by 디어스 (D.US)
