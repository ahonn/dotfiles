#!/usr/bin/env bash
# Co-update Homebrew brew tag + core/cask/bundle lock entries.
#
# Why: nix-homebrew pins brew to a release tag while homebrew-core floats.
# Updating core alone leaves brew on an older DSL and breaks formula install
# (e.g. openssl@3: unknown keyword :overwrite / if_path_exists).
#
# Usage:
#   ./scripts/update-homebrew-inputs.sh           # bump brew to latest stable + update locks
#   ./scripts/update-homebrew-inputs.sh --check   # canary only (needs working brew on PATH)
#   ./scripts/update-homebrew-inputs.sh --dry-run  # print planned brew tag bump only

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

FLAKE_NIX="$ROOT/flake.nix"
FLAKE_LOCK="$ROOT/flake.lock"

usage() {
  sed -n '2,12p' "$0" | sed 's/^# \?//'
}

current_brew_tag() {
  python3 - <<'PY'
import json
from pathlib import Path
lock = json.loads(Path("flake.lock").read_text())
print(lock["nodes"]["homebrew-brew"]["original"]["ref"])
PY
}

latest_brew_tag() {
  curl -fsSL "https://api.github.com/repos/Homebrew/brew/releases/latest" |
    python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"])'
}

set_brew_tag_in_flake() {
  local tag="$1"
  # Replace only the homebrew-brew URL tag: github:Homebrew/brew/<tag>
  python3 - "$FLAKE_NIX" "$tag" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
tag = sys.argv[2]
text = path.read_text()
new, n = re.subn(
    r'(url\s*=\s*"github:Homebrew/brew/)[^"]+(")',
    rf"\g<1>{tag}\2",
    text,
    count=1,
)
if n != 1:
    sys.exit(f"expected to rewrite exactly 1 homebrew-brew url, rewrote {n}")
path.write_text(new)
print(f"flake.nix: homebrew-brew -> {tag}")
PY
}

brew_compat_check() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "brew not on PATH; skip compat check" >&2
    return 0
  fi

  echo "Canary: parse DSL-sensitive formulae with $(brew --version | head -1)"
  local f
  # openssl@3 and node are the packages that previously failed on stale brew pins.
  for f in openssl@3 node; do
    if ! brew info --json=v2 "$f" >/dev/null 2>&1; then
      echo "FAIL: brew cannot load formula: $f" >&2
      echo "Bump brew via $0 (without --check) and rebuild." >&2
      return 1
    fi
    echo "  ok $f"
  done
  echo "Canary passed."
}

main() {
  local mode="update"
  case "${1:-}" in
    -h | --help)
      usage
      exit 0
      ;;
    --check)
      mode="check"
      ;;
    --dry-run)
      mode="dry-run"
      ;;
    "")
      mode="update"
      ;;
    *)
      echo "unknown arg: $1" >&2
      usage >&2
      exit 2
      ;;
  esac

  if [[ ! -f $FLAKE_NIX || ! -f $FLAKE_LOCK ]]; then
    echo "run from nix-darwin repo (missing flake.nix / flake.lock)" >&2
    exit 1
  fi

  if [[ $mode == "check" ]]; then
    brew_compat_check
    exit $?
  fi

  local current latest
  current="$(current_brew_tag)"
  latest="$(latest_brew_tag)"
  echo "brew pin: $current"
  echo "brew latest stable: $latest"

  if [[ $mode == "dry-run" ]]; then
    if [[ $current == "$latest" ]]; then
      echo "dry-run: brew already on latest; would still refresh core/cask/bundle locks"
    else
      echo "dry-run: would bump brew $current -> $latest and update locks"
    fi
    exit 0
  fi

  if [[ $current != "$latest" ]]; then
    set_brew_tag_in_flake "$latest"
  else
    echo "flake.nix already pins brew $latest"
  fi

  echo "Updating flake inputs: homebrew-brew homebrew-core homebrew-cask homebrew-bundle"
  nix flake update homebrew-brew homebrew-core homebrew-cask homebrew-bundle

  echo
  echo "Done. Locked brew tag: $(current_brew_tag)"
  echo "Next: sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#workstation"
  echo "Then: ./scripts/update-homebrew-inputs.sh --check"
}

main "$@"
