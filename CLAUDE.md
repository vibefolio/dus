# DUS (디어스) — 프로젝트 개발 가이드

## 프로젝트 개요
AI와 현대적 디자인이 조화된 프리미엄 웹 에이전시 플랫폼. 디자인 템플릿 마켓플레이스 + 견적 시스템 + 멀티테넌시 에이전시 관리.
- **도메인**: designd.co.kr, dus.vibers.co.kr
- **운영**: 계발자들 (Vibers) — vibers.co.kr
- **GitHub**: https://github.com/vibefolio/dus

## 상위 브랜드
계발자들 (Vibers) — vibers.co.kr / server.vibers.co.kr

## 기술 스택
| 항목 | 기술 |
|------|------|
| Framework | Ruby on Rails 8.1.1 (풀스택) |
| Language | Ruby 3.4.7 |
| Frontend | Hotwire (Turbo + Stimulus) |
| Styling | Tailwind CSS |
| Asset Pipeline | Propshaft |
| JS 관리 | Importmap |
| Database | SQLite (dev/prod) / PostgreSQL (prod 옵션) |
| Auth | Devise + Google OAuth |
| PDF | Prawn + Prawn-table |
| Pagination | Kaminari |
| Security | Rack::Attack (rate limiting) |
| Image | Active Storage + ImageProcessing |
| Server | Puma + Thruster |
| Container | Docker |

## 프로젝트 구조
```
dus/
├── app/
│   ├── controllers/
│   │   ├── admin/              ← 관리자 (대시보드, 템플릿, 견적, 주문)
│   │   ├── users/              ← OAuth 콜백
│   │   ├── application_controller.rb ← 서브도메인 감지
│   │   ├── carts_controller.rb
│   │   ├── design_templates_controller.rb
│   │   ├── orders_controller.rb
│   │   ├── pages_controller.rb ← 홈, 포트폴리오, 연락처, 가격
│   │   └── mypage_controller.rb
│   ├── models/
│   │   ├── user.rb             ← Devise + OAuth, 4단계 역할
│   │   ├── agency.rb           ← 멀티테넌시 핵심 (재귀 구조)
│   │   ├── design_template.rb  ← 템플릿 (DB + YAML 정적)
│   │   ├── order.rb            ← 주문 (에이전시 자동 생성)
│   │   ├── quote.rb            ← 견적 워크플로우
│   │   └── portfolio.rb        ← 포트폴리오 쇼케이스
│   ├── views/                  ← ERB 템플릿
│   ├── assets/stylesheets/
│   │   └── application.tailwind.css ← 커스텀 컴포넌트
│   ├── javascript/
│   │   └── controllers/
│   │       └── honeypot_controller.js ← 스팸 방지
│   └── mailers/
│       └── quote_mailer.rb     ← 견적 이메일
├── config/
│   ├── routes.rb               ← 라우팅
│   ├── tailwind.config.js      ← Tailwind 설정
│   ├── templates.yml           ← 정적 템플릿 데이터
│   └── importmap.rb            ← JS 의존성
├── db/
│   ├── migrate/                ← 118+ 마이그레이션
│   ├── schema.rb               ← DB 스키마
│   └── seeds.rb                ← 26개 디자인 템플릿
├── Dockerfile
├── docker-compose.yml
├── .github/workflows/deploy.yml
├── CLAUDE.md                   ← 이 파일
└── README.md
```

## 핵심 파일
| 파일 | 설명 |
|------|------|
| app/models/agency.rb | 멀티테넌시 핵심 (재귀 에이전시, 서브도메인) |
| app/models/user.rb | Devise + OAuth, super_admin/owner/admin/user 역할 |
| app/models/order.rb | 결제 완료 시 에이전시 자동 생성 |
| app/models/design_template.rb | DB + YAML 하이브리드 템플릿 |
| app/controllers/application_controller.rb | 서브도메인 감지, 에이전시 컨텍스트 |
| app/assets/stylesheets/application.tailwind.css | 디자인 시스템 (컬러, 버튼, 카드) |
| config/templates.yml | 정적 템플릿 데이터 (26개 카테고리) |

## 디자인 특징
- Primary 컬러: #00a859 (그린), 그라디언트 버튼
- Glassmorphism, 둥근 모서리, 그림자 레이어
- Tailwind 커스텀 컴포넌트 (@layer components)
→ 상세 내용은 DESIGN_GUIDE.md 참조

## 개발 규칙
### 코드 스타일
- Hotwire 중심 (Turbo Drive/Frame/Stream)
- Stimulus 컨트롤러로 JS 최소화
- ERB 뷰 (Jbuilder for JSON)
- 시맨틱 HTML + Tailwind 유틸리티
- 한글 우선 (모든 UI, flash, validation)

### 멀티테넌시 규칙
- 서브도메인 기반 Agency 감지 (application_controller)
- 역할: super_admin > owner > admin > user
- 데이터 격리: Agency scoped queries
- 결제 완료 → Agency 자동 생성 → Owner 권한 부여

### Git 규칙
- 한글 커밋 (feat:, fix:, refactor:, chore: 접두사)
- 에이전트 태그 필수: [AG], [CC], [TCC], [APP]
- `git add .` 사용 금지 → 항상 `git add <특정 파일>`
- 커밋 전 `git pull origin main` 실행

### 배포
- GitHub Actions → SSH → NCP Docker 자동 재빌드

## 멀티 에이전트 협업 체계

| 태그 | 환경 | 역할 |
|------|------|------|
| [AG] | AntiGravity (VS Code 익스텐션) | 코딩 메인. LEO가 직접 지시 |
| [CC] | Claude Code (VS Code) | 단일 앱 작업 |
| [TCC] | Claude Code (터미널 / iTerm2) | 병렬 작업 |
| [APP] | Claude Code (앱, 클라우드) | 보조 작업 |
| [CW] | Claude Cowork (데스크톱) | 비코딩 (서버 관리, 문서) |

## NCP 서버 정보
- **IP**: 49.50.138.93
- **SSH**: ssh root@49.50.138.93
- **프로젝트 경로**: /root/projects/dlab-website/
- **Docker 네트워크**: npm_default

## 포트맵
| 포트 | 컨테이너명 | 도메인 |
|------|-----------|--------|
| 4040 | dlab-website-app | designd.co.kr, dus.vibers.co.kr |

## Docker 구성
- **컨테이너**: `dlab-website-app`
- **포트**: `4040:80`
- **DB**: SQLite (volume: `dlab_website_storage:/rails/storage`)
- **헬스체크**: `GET /up` → HTTP 200
- **네트워크**: npm_default (external: true)
- **restart**: unless-stopped
- **환경변수**: .env 파일로 관리

## 환경변수 (.env — 서버에만 존재, git 제외)
```
RAILS_ENV=production
RAILS_MASTER_KEY=fca4828212ca75b0568c2d2c15cb2f53
RAILS_LOG_TO_STDOUT=1
RAILS_SERVE_STATIC_FILES=true
```

## 배포 방식
- `.github/workflows/deploy.yml` (GitHub Actions)
- `git push origin main` → SSH → Docker Compose down → up --build
- GitHub Secrets: NCP_HOST, NCP_USER, NCP_SSH_KEY

## SSL 절대 규칙
- Cloudflare Full Mode (주황구름 ON)
- NPM에서 Let's Encrypt 발급하지 마!
- NPM에서는 HTTP 프록시만 설정
- server, *.server 만 DNS Only (회색구름)

## 주요 설정 결정사항
- `config.assume_ssl = true` — Cloudflare가 SSL 처리
- `config.force_ssl = true` — assume_ssl과 함께 사용 (리다이렉트 루프 없음)
- `config.active_storage.service = :local` — 로컬 볼륨 스토리지
- `config.host_authorization` — `/up` 헬스체크 경로 제외
- `config.hosts` — designd.co.kr, dus.vibers.co.kr, *.designd.co.kr

## 이전 배포 이력
- Fly.io → NCP Docker 이전 완료 (2026-03-24)
- Fly.io 앱 `dlab-website` 삭제 완료

## 주요 명령어
```bash
# 개발 서버
bin/rails server

# DB 마이그레이션
bin/rails db:migrate

# 시드 데이터
bin/rails db:seed

# 콘솔
bin/rails console

# 라우팅 확인
bin/rails routes

# Docker (프로덕션)
docker compose up -d --build
```

## 작업 방식 (중요)
- 테스트/배포 후 성공 시: **"자동배포 확인 완료!"** 처럼 한 줄로만 보고
- 실패 시: 에러 내용 바로 출력
- 응답은 짧고 간결하게

## 현재 작업 (NOW)
<!-- 작업 중단 시 여기에 기록 — 다음 에이전트가 이어받을 수 있도록 -->
- 진행 중: 없음
- 마지막 완료: Fly.io → NCP Docker 이전 (2026-03-24)
- 다음 할 일: OKR.md의 KR 기준으로 우선순위 높은 것부터
