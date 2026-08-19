#!/usr/bin/env python3
"""3D 아이콘 시트를 개별 투명 PNG로 추출한다.

사용법:
    python3 script/extract_icons.py                # 전체 시트 처리
    python3 script/extract_icons.py s27_45         # 특정 시트만

입력:  marketing/assets/icons-3d/sheets/*.png
출력:  marketing/assets/icons-3d/extracted/{시트ID}-{NN}.png
       marketing/assets/icons-3d/extracted/_contact-{시트ID}.png  (흰 배경 검수용)

배경 분리 방식
--------------
시트에 알파 채널이 있으면 그대로 쓴다.
없으면 '선명도' 로 가른다 — 배경은 가우시안 글로우로 뭉개져 있고 아이콘은 샤프하다.
색으로 가르는 플러드필은 쓰지 않는다: 아이콘 초록과 배경 초록이 같은 계열이라
아이콘 본체가 통째로 지워진다 (2026-08-17 실패 확인).
"""

import sys
import subprocess
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter
from scipy import ndimage

ROOT = Path(__file__).resolve().parent.parent
SHEETS = ROOT / "marketing/assets/icons-3d/sheets"
OUT = ROOT / "marketing/assets/icons-3d/extracted"

MIN_AREA = 3000      # 이보다 작은 덩어리는 글로우 잔여물로 본다
HF_THRESHOLD = 12    # |img - blur| 임계값
CANVAS = 256         # 출력 정사각 캔버스
PAD_RATIO = 0.06     # 여백


def build_mask(im: Image.Image) -> np.ndarray:
    """아이콘 영역 불리언 마스크."""
    if im.mode == "RGBA" and np.asarray(im)[:, :, 3].min() == 0:
        mask = np.asarray(im)[:, :, 3] > 60
    else:
        rgb = im.convert("RGB")
        arr = np.asarray(rgb).astype(float)
        blur = np.asarray(rgb.filter(ImageFilter.GaussianBlur(6))).astype(float)
        mask = np.abs(arr - blur).max(axis=2) > HF_THRESHOLD

    mask = ndimage.binary_closing(mask, np.ones((11, 11)))
    mask = ndimage.binary_fill_holes(mask)
    mask = ndimage.binary_opening(mask, np.ones((5, 5)))
    return mask


def components(mask: np.ndarray):
    """읽는 순서(위→아래, 왼→오른쪽)로 정렬된 (bbox, 라벨마스크) 목록."""
    lab, n = ndimage.label(mask)
    sizes = ndimage.sum(mask, lab, range(1, n + 1))
    slices = ndimage.find_objects(lab)

    items = []
    for i, size in enumerate(sizes):
        if size < MIN_AREA:
            continue
        sy, sx = slices[i]
        items.append({"label": i + 1, "sy": sy, "sx": sx})

    if not items:
        return []

    # 행 단위로 묶어 정렬한다. 아이콘 높이의 절반을 행 허용오차로 쓴다.
    heights = [it["sy"].stop - it["sy"].start for it in items]
    tol = int(np.median(heights) * 0.6)
    items.sort(key=lambda it: (it["sy"].start // tol, it["sx"].start))
    return items, lab


def extract_one(im: Image.Image, lab: np.ndarray, item) -> Image.Image:
    sy, sx = item["sy"], item["sx"]
    region = (lab[sy, sx] == item["label"])

    alpha = Image.fromarray((region * 255).astype("uint8"))
    alpha = alpha.filter(ImageFilter.GaussianBlur(0.6))

    crop = im.convert("RGB").crop((sx.start, sy.start, sx.stop, sy.stop))
    icon = crop.convert("RGBA")
    icon.putalpha(alpha)

    # 정사각 캔버스에 여백을 두고 앉힌다
    w, h = icon.size
    side = int(max(w, h) * (1 + PAD_RATIO * 2))
    canvas = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    canvas.paste(icon, ((side - w) // 2, (side - h) // 2), icon)
    return canvas.resize((CANVAS, CANVAS), Image.LANCZOS)


def contact_sheet(icons, path: Path, cols=8):
    """흰 배경 위 대조 시트 — 배경 잔여·헤일로를 눈으로 잡기 위한 것."""
    cell = 160
    rows = (len(icons) + cols - 1) // cols
    sheet = Image.new("RGB", (cols * cell, rows * cell), (255, 255, 255))
    for i, ic in enumerate(icons):
        thumb = ic.resize((cell - 16, cell - 16), Image.LANCZOS)
        sheet.paste(thumb, ((i % cols) * cell + 8, (i // cols) * cell + 8), thumb)
    sheet.save(path)


def process(sheet_path: Path):
    sid = sheet_path.stem
    im = Image.open(sheet_path)
    mask = build_mask(im)
    result = components(mask)
    if not result:
        print(f"{sid}: 검출 0 — 건너뜀")
        return 0
    items, lab = result

    icons = []
    for idx, item in enumerate(items, 1):
        icon = extract_one(im, lab, item)
        out = OUT / f"{sid}-{idx:02d}.png"
        icon.save(out)
        subprocess.run(
            ["pngquant", "--quality", "65-90", "--force", "--skip-if-larger",
             "--output", str(out), str(out)],
            check=False, capture_output=True,
        )
        icons.append(icon)

    contact_sheet(icons, OUT / f"_contact-{sid}.png")
    print(f"{sid}: {len(icons)}개 추출")
    return len(icons)


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    targets = sorted(SHEETS.glob("*.png"))
    if len(sys.argv) > 1:
        wanted = set(sys.argv[1:])
        targets = [p for p in targets if p.stem in wanted]
        if not targets:
            sys.exit(f"해당 시트 없음: {', '.join(wanted)}")

    total = sum(process(p) for p in targets)
    print(f"\n합계 {total}개 → {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
