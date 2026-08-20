# DUS 마케팅 자산

표준: `~/Desktop/macminim4/ops/marketing/marketing-standard.md`

## assets/icons-3d/ — 그린 3D 아이콘 셋

| 항목 | 값 |
|------|-----|
| 원본 시트 | `sheets/*.png` 10장 (ChatGPT 생성, 2026-08-17 · 08-19) |
| 추출본 | `extracted/` — 381개. **gitignore** (스크립트로 재생성 가능) |
| 채택본 | `../../app/assets/images/icons/` 66개 (256px 투명 PNG) |
| 매니페스트 | `../../config/icons.yml` |

### 재생성
```bash
python3 script/extract_icons.py     # 시트 → 개별 투명 PNG + 검수용 컨택트시트
python3 script/curate_icons.py      # 채택본만 app/assets/images/icons/ 로 배치
```

### 시트 추가할 때
1. 새 시트를 `sheets/sNNNN.png` 로 저장
2. `python3 script/extract_icons.py sNNNN` 실행
3. `extracted/_contact-sNNNN.png` 를 **눈으로 확인** — 배경 잔여·헤일로·병합/분리 실패 검수
4. 쓸 것을 `script/curate_icons.py` 의 `SELECTION` 에 추가 후 재실행
5. `config/icons.yml` 에 이름·라벨 등록

### 알아둘 것
- 아이콘 원본 렌더가 ~170px다(256px 캔버스로 업스케일). 표시 크기는
  **배지·필터 26~30px / 카드 44~70px / 메인 강조 72~104px**, 상한 약 110px.
  110px을 넘으면 2x DPI에서 원본을 넘어서 부드러워진다.
- 배경 분리는 **색이 아니라 선명도**로 한다. 색 기반 플러드필은 아이콘 초록이
  배경 초록과 같은 계열이라 본체를 통째로 지운다 (2026-08-17 실패).
- 톤은 **진한 초록 + 옐로우 액센트** 계열로 통일했다. 연두 계열 시트(s27_35·s27_39)는
  같이 놓으면 색이 튀어서 채택하지 않았다.
- 진한 그라디언트/유채색 배경 위에는 올리지 않는다 — 아이콘 자체 색과 섞여 탁해진다.
  그래서 admin 대시보드 KPI 카드(파랑·보라·주황)는 흰색 stroke SVG를 그대로 뒀다.

## 과업 로그
- 2026-08-19 — 3D 아이콘 셋 10장 수령 → 381개 추출 → 66개 큐레이션 → 라이브러리화 및
  이모지 11곳·카테고리 배지·피처 타일 11곳 교체. 카테고리 라벨을 `config/icons.yml` 단일
  출처로 통합해 admin `finance` 누락과 공개 필터 5개 도달 불가 동시 해소.
