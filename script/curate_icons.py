#!/usr/bin/env python3
"""추출된 381개 중 실제로 쓸 것만 골라 app/assets/images/icons/ 로 배치한다.

    python3 script/curate_icons.py

SELECTION 의 키는 최종 경로, 값은 extracted/ 안의 파일명이다.
같은 개념이 여러 시트에 중복 등장하므로 '가장 깨끗하고 톤이 맞는 것' 하나만 채택한다.

톤 기준: DUS primary #00a859 에 맞춰 **진한 초록 + 옐로우 액센트** 계열(s28_*, s27_45, s27_49)로
통일한다. 연두색 계열(s27_35, s27_39)은 같이 놓으면 색이 튀어서 쓰지 않는다.

제외한 것:
    s28_16-26 (장바구니) · s28_16-31 (헤드셋) — 원본 시트의 알파 채널이 깨져 얼룩·구멍이 있다
    s28_31-14 · s28_27-36 — 인접 아이콘 병합 / 조각 분리 실패본
"""

import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "marketing/assets/icons-3d/extracted"
DEST = ROOT / "app/assets/images/icons"

SELECTION = {
    # ── industry/ : DesignTemplate.category 14개 키에 1:1 대응 ──────────────
    "industry/beauty.png":     "s28_22-06.png",  # 드라이기 + 가위
    "industry/dining.png":     "s28_22-04.png",  # 접시 + 셰프모자
    "industry/fitness.png":    "s28_22-09.png",  # 러닝화 + 덤벨
    "industry/space.png":      "s27_45-30.png",  # 암체어
    "industry/stay.png":       "s28_22-12.png",  # 캐리어 + 비행기
    "industry/shopping.png":   "s28_22-11.png",  # 쇼핑백 + 카트 + 선물
    "industry/corporate.png":  "s28_22-14.png",  # 오피스 빌딩
    "industry/cafe.png":       "s28_22-03.png",  # 커피 + 크루아상
    "industry/portfolio.png":  "s28_22-20.png",  # 카메라 + 사진
    "industry/medical.png":    "s28_22-07.png",  # 차트 + 청진기
    "industry/law.png":        "s27_49-01.png",  # 저울
    "industry/academy.png":    "s28_22-10.png",  # 학사모 + 책
    "industry/kinder.png":     "s27_49-08.png",  # 곰인형
    "industry/finance.png":    "s28_22-15.png",  # 돼지저금통 + 카드

    # ── core/ : 서비스·프로세스·성과 ─────────────────────────────────────
    "core/rocket.png":         "s28_27-07.png",
    "core/target.png":         "s28_27-02.png",
    "core/idea.png":           "s28_27-01.png",
    "core/shield.png":         "s28_27-13.png",
    "core/handshake.png":      "s28_27-14.png",
    "core/trophy.png":         "s28_27-35.png",
    "core/clock.png":          "s28_27-25.png",
    "core/growth.png":         "s28_27-06.png",
    "core/pie-chart.png":      "s28_31-34.png",
    "core/presentation.png":   "s28_31-18.png",
    "core/checklist.png":      "s28_27-24.png",
    "core/document.png":       "s28_27-33.png",
    "core/contract.png":       "s28_16-34.png",
    "core/briefcase.png":      "s28_16-06.png",
    "core/stopwatch.png":      "s28_16-14.png",
    "core/puzzle.png":         "s28_31-21.png",
    "core/paper-plane.png":    "s28_27-34.png",
    "core/design.png":         "s28_16-08.png",  # 모니터 + 붓
    "core/calendar.png":       "s28_27-05.png",
    "core/package.png":        "s27_45-14.png",

    # ── commerce/ ────────────────────────────────────────────────────────
    "commerce/cart.png":       "s28_31-02.png",
    "commerce/bag.png":        "s28_31-03.png",
    "commerce/gift.png":       "s28_31-04.png",
    "commerce/tag.png":        "s28_31-05.png",
    "commerce/wallet.png":     "s28_31-06.png",
    "commerce/card.png":       "s28_27-17.png",
    "commerce/pos.png":        "s28_31-08.png",
    "commerce/truck.png":      "s28_27-18.png",
    "commerce/shop.png":       "s28_31-01.png",

    # ── social/ : 소통·콘텐츠·인프라 ────────────────────────────────────
    "social/chat.png":         "s28_27-30.png",
    "social/mail.png":         "s28_16-21.png",  # 봉투 + 알림벨
    "social/bell.png":         "s28_31-11.png",
    "social/share.png":        "s28_31-15.png",
    "social/link.png":         "s28_31-16.png",
    "social/review.png":       "s28_31-13.png",  # 별점 말풍선
    "social/team.png":         "s28_27-31.png",
    "social/headset.png":      "s28_27-29.png",
    "social/id-card.png":      "s28_31-23.png",
    "social/camera.png":       "s28_27-22.png",
    "social/video.png":        "s28_27-26.png",
    "social/image.png":        "s28_31-41.png",
    "social/globe.png":        "s28_27-20.png",  # www 지구본
    "social/qr.png":           "s28_27-21.png",
    "social/map-pin.png":      "s28_27-19.png",
    "social/mobile.png":       "s28_27-04.png",
    "social/browser-search.png": "s28_31-25.png",
    "social/cloud-up.png":     "s28_27-10.png",
    "social/cloud-down.png":   "s28_27-11.png",
    "social/server.png":       "s28_27-12.png",
    "social/database.png":     "s28_31-30.png",
    "social/folder.png":       "s28_31-32.png",
    "social/lock.png":         "s28_22-28.png",  # 방패 + 자물쇠
}


def main():
    missing = [src for src in SELECTION.values() if not (SRC / src).exists()]
    if missing:
        sys.exit("추출본 없음 — script/extract_icons.py 먼저 실행:\n  " + "\n  ".join(missing))

    for dest_rel, src_name in SELECTION.items():
        dest = DEST / dest_rel
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(SRC / src_name, dest)

    print(f"{len(SELECTION)}개 배치 → {DEST.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
