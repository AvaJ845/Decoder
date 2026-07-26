#!/usr/bin/env python3
"""
keygen — extract every assetKey a content pack references and report production status.

Sprint 0 reference tool for DE-Art: the input to per-word/per-chunk tile production.
Groups keys by kind (chunk prompt / word card / audio) and marks which already have a
concrete source file vs. which must be produced from a template.

Usage:
    python3 tools/keygen.py ../assets/code/chunk-racer-basics-pack.json
"""
import json
import sys
from collections import defaultdict
from pathlib import Path

# Keys with a concrete delivered source (from ASSET_KEY_MAP). Everything else is
# produced from a template. Reusable state assets (hit/reserve) count as delivered.
DELIVERED = {
    "racer_track_lane", "racer_vehicle_idle", "racer_vehicle_hit",
    "racer_target_chunk", "racer_chunk_tile", "racer_chunk_tile_hit",
    "racer_chunk_tile_reserve", "racer_word_card",
    "kit_guide_arlo_idle", "kit_guide_arlo_celebrate",
    "kit_guide_arlo_encourage", "kit_guide_arlo_think",
    "ui_momentum_protected", "ui_feedback_gentle_reserve",
}


def kind(key: str) -> str:
    if key.startswith("racer_audio_"):
        return "audio"
    if key.startswith("racer_chunk_"):
        return "chunk-prompt"
    if key.startswith("racer_word_"):
        return "word-card"
    return "other"


def main() -> int:
    if len(sys.argv) != 2:
        print(__doc__)
        return 2
    pack = json.loads(Path(sys.argv[1]).read_text())

    by_kind = defaultdict(set)
    for item in pack["items"]:
        for key in item.get("assetKeys", []):
            by_kind[kind(key)].add(key)

    total = need = 0
    for k in ("chunk-prompt", "word-card", "audio", "other"):
        keys = sorted(by_kind.get(k, []))
        if not keys:
            continue
        print(f"\n## {k}  ({len(keys)})")
        for key in keys:
            total += 1
            status = "delivered" if key in DELIVERED else "PRODUCE"
            if status == "PRODUCE":
                need += 1
            print(f"  [{status:9}] {key}")

    print(f"\n{total} unique keys · {need} to produce · {total - need} delivered")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
