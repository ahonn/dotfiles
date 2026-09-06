#!/usr/bin/env bash
# Update the Homebrew flake inputs (brew + every tap) together.
#
# Why: brew and the taps are separate flake inputs. brew tracks master and the
# taps track their default branches, so they only stay DSL-compatible when
# they move together. Updating a tap alone can pull in stanzas the locked brew
# does not know yet:
#   openssl@3: unknown keyword :overwrite / if_path_exists
#   aerospace: unknown keyword :must_succeed (postflight_steps `run`)
#
# Usage:
#   ./scripts/update-homebrew-inputs.sh           # update every homebrew-* input
#   ./scripts/update-homebrew-inputs.sh --check   # canary only (needs working brew on PATH)

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

usage() {
  sed -n '2,13p' "$0" | sed -E 's/^# ?//'
}

# Every root flake input named homebrew-*: brew itself plus all taps.
homebrew_inputs() {
  python3 - <<'PY'
import json
from pathlib import Path
lock = json.loads(Path("flake.lock").read_text())
root = lock["nodes"][lock["root"]]["inputs"]
print("\n".join(sorted(k for k in root if k.startswith("homebrew-"))))
PY
}

# Store name of the installed brew, e.g. brew-20260905-08e85c4-patched.
installed_brew() {
  local lib
  lib="$(readlink -f "$(brew --prefix)/Library/Homebrew")"
  basename "$(dirname "$(dirname "$lib")")" | cut -d- -f2-
}

brew_compat_check() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "brew not on PATH; skip compat check" >&2
    return 0
  fi

  echo "Canary: parse DSL-sensitive packages with $(installed_brew)"
  local f
  # Packages that previously failed to parse on a stale brew:
  # openssl@3 / node (core formulae), aerospace (third-party cask).
  for f in openssl@3 node nikitabobko/tap/aerospace; do
    if ! brew info --json=v2 "$f" >/dev/null 2>&1; then
      echo "FAIL: brew cannot load package: $f" >&2
      echo "Update brew together with the taps via $0 and rebuild." >&2
      return 1
    fi
    echo "  ok $f"
  done
  echo "Canary passed."
}

main() {
  case "${1:-}" in
    -h | --help)
      usage
      exit 0
      ;;
    --check)
      brew_compat_check
      exit $?
      ;;
    "") ;;
    *)
      echo "unknown arg: $1" >&2
      usage >&2
      exit 2
      ;;
  esac

  if [[ ! -f flake.nix || ! -f flake.lock ]]; then
    echo "run from nix-darwin repo (missing flake.nix / flake.lock)" >&2
    exit 1
  fi

  local -a inputs
  # shellcheck disable=SC2207  # input names never contain whitespace
  inputs=($(homebrew_inputs))
  echo "Updating flake inputs: ${inputs[*]}"
  nix flake update "${inputs[@]}"

  echo
  echo "Next: sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#workstation"
  echo "Then: ./scripts/update-homebrew-inputs.sh --check"
}

main "$@"
