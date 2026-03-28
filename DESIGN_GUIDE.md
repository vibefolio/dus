# DUS (디어스) — 디자인 가이드

> 상위 브랜드: 계발자들 (Vibers)
> 디자인 아이덴티티: 프리미엄, 신뢰, 현대적

## 컬러 시스템

### 핵심 컬러 팔레트
| 역할 | 값 | CSS 변수 | 설명 |
|------|-----|---------|------|
| Primary | #00a859 | --color-primary | 메인 그린 |
| Primary Dark | #008a47 | --color-primary-dark | 호버/액티브 |
| Accent | #00d670 | --color-accent | 강조 그린 |
| Success | #10b981 | --color-success | 성공 상태 |
| Warning | #f59e0b | --color-warning | 경고 상태 |
| Error | #ef4444 | --color-error | 에러 상태 |

### 컬러 사용 규칙
- Primary 그라디언트: `from-[#00a859] to-[#00d670]` (CTA 버튼)
- 배경: 흰색 (#FFFFFF) 기본, 그레이 (#F9FAFB) 섹션 교차
- 텍스트: #111827 (제목), #4B5563 (본문), #9CA3AF (보조)

## 타이포그래피

### 폰트 스택
- 한글: 시스템 기본 (Apple SD Gothic Neo)
- 영문: 시스템 기본 (SF Pro)
- 코드: monospace

### 제목 계층
| 레벨 | Tailwind | 용도 |
|------|---------|------|
| H1 | text-4xl font-bold | 히어로 제목 |
| H2 | text-3xl font-semibold | 섹션 제목 |
| H3 | text-xl font-semibold | 카드 제목 |
| Body | text-base | 본문 |
| Small | text-sm | 보조 텍스트 |

## 레이아웃

### 반응형 브레이크포인트
- sm: 640px, md: 768px, lg: 1024px, xl: 1280px

### 컨테이너
- `.container`: max-w-7xl mx-auto px-6

### 섹션 간격
- `.section`: py-24

## 컴포넌트 패턴

### 버튼 (application.tailwind.css 기반)
| 클래스 | 스타일 | 용도 |
|--------|--------|------|
| .btn | px-8 py-4 rounded-lg font-semibold | 기본 |
| .btn-primary | 그린 그라디언트 + 호버 scale | 주요 CTA |
| .btn-outline | 그린 보더 + 투명 배경 | 보조 |
| .btn-accent | 흰색 배경 + 그린 텍스트 | 반전 |
| .btn-lg | px-10 py-5 text-lg | 큰 버튼 |

### 카드
```css
.card: bg-white rounded-2xl shadow-lg p-8 hover:shadow-2xl transition
```

### 네비게이션
```css
.navbar: fixed top-0 bg-white shadow-md z-50
```

### 히어로
```css
.hero: min-h-screen flex items-center bg-gradient-to-br from-[#00a859] to-[#00d670] text-white
```

## 접근성
- WCAG 2.1 AA 기준
- 키보드 포커스 표시
- 최소 터치 영역 44px
- 다크모드: 미지원 (향후 계획)

---

**마지막 업데이트**: 2026-03-24
