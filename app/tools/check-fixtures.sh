#!/usr/bin/env bash
# Guards the content fixtures against drift. `assets/code/` is the source of truth;
# the app bundle and the test target keep their own copies (different bundling systems).
# Fails (non-zero) if any copy has diverged from the source. Run from anywhere.
set -euo pipefail
cd "$(dirname "$0")/.."   # -> app/

src="assets/code"
consumers=(
  "ChunkRacerApp/Resources"
  "Tests/DecoderCoreTests/Resources"
)
files=("chunk-racer-basics-pack.json" "skill-graph.json")

status=0
for f in "${files[@]}"; do
  for c in "${consumers[@]}"; do
    if ! diff -q "$src/$f" "$c/$f" >/dev/null 2>&1; then
      echo "DRIFT: $c/$f differs from source $src/$f"
      status=1
    fi
  done
done

if [ "$status" -eq 0 ]; then
  echo "✓ content fixtures in sync ($src is source of truth)"
fi
exit "$status"
