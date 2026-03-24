# dlab-website 프로젝트 컨텍스트

## 프로젝트 개요
- **이름**: dlab-website (디자인드 웹사이트)
- **스택**: Rails 8.1, Ruby 3.4.7, SQLite, Tailwind CSS, Thruster
- **GitHub**: https://github.com/vibefolio/dus
- **로컬 경로**: `/Users/admin/Desktop/dus/dlab-website/`

## 서버 정보
- **NCP 서버**: `root@49.50.138.93`
- **SSH 키**: `~/.ssh/id_ncp`
- **배포 경로**: `/root/projects/dlab-website/`
- **Docker 네트워크**: `npm_default` (external)

## 도메인
- `designd.co.kr` → NPM → `dlab-website-app:80`
- `dus.vibers.co.kr` → NPM → `dlab-website-app:80`
- SSL: Cloudflare Full Mode (NPM에서 SSL 발급 안 함)

## Docker 구성
- **컨테이너**: `dlab-website-app`
- **포트**: `4040:80`
- **DB**: SQLite (volume: `dlab_website_storage:/rails/storage`)
- **헬스체크**: `GET /up` → HTTP 200

## GitHub Actions 자동배포
- 파일: `.github/workflows/deploy.yml`
- 트리거: `push to main`
- Secrets (GitHub에 등록):
  - `NCP_HOST`: `49.50.138.93`
  - `NCP_USER`: `root`
  - `NCP_SSH_KEY`: `~/.ssh/id_ncp` 개인키 내용

## 환경변수 (.env — 서버에만 존재, git 제외)
```
RAILS_ENV=production
RAILS_MASTER_KEY=fca4828212ca75b0568c2d2c15cb2f53
RAILS_LOG_TO_STDOUT=1
RAILS_SERVE_STATIC_FILES=true
```

## 주요 설정 결정사항
- `config.assume_ssl = true` — Cloudflare가 SSL 처리
- `config.force_ssl = true` — assume_ssl과 함께 사용 (리다이렉트 루프 없음)
- `config.active_storage.service = :local` — Fly.io Tigris에서 로컬 볼륨으로 전환
- `config.host_authorization` — `/up` 헬스체크 경로 제외
- `config.hosts` — `designd.co.kr`, `dus.vibers.co.kr` (Fly.io/onrender 제거)

## 이전 배포 이력
- Fly.io → NCP Docker 이전 완료 (2026-03-24)
- Fly.io 앱 `dlab-website` 삭제 완료

## 작업 방식 (중요)
- 테스트/배포 후 성공 시: **"자동배포 확인 완료!"** 처럼 한 줄로만 보고
- 실패 시: 에러 내용 바로 출력
- 응답은 짧고 간결하게
