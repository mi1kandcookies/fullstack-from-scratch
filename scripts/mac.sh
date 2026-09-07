#!/usr/bin/env bash
# fullstack-from-scratch — macOS. Homebrew first, then everything through it.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$here/common.sh" "$@"

say "Xcode Command Line Tools"
if xcode-select -p >/dev/null 2>&1; then note "already installed"; SKIPPED+=("Xcode CLT")
else
  note "installing — approve the dialog, then re-run this script when it finishes"
  run xcode-select --install; [ "$DRY" = 1 ] || exit 0
fi

say "Homebrew"
if have brew; then note "already installed"; SKIPPED+=("Homebrew")
else
  run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  INSTALLED+=("Homebrew")
fi
# Apple Silicon puts brew in /opt/homebrew; make sure this shell and future ones see it.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  rc_line 'eval "$(/opt/homebrew/bin/brew shellenv)"'
fi

say "Packages (Brewfile)"
if [ "$NO_APPS" = 1 ]; then
  # Formulae only: strip the casks.
  tmp="$(mktemp)"; grep -v '^cask ' "$here/../Brewfile" > "$tmp"
  run brew bundle --file="$tmp"
else
  run brew bundle --file="$here/../Brewfile"
fi
INSTALLED+=("Brewfile packages")

say "Node (LTS via fnm)"
rc_line 'eval "$(fnm env --use-on-cd --shell zsh)"'
if [ "$DRY" = 0 ]; then eval "$(fnm env)"; fi
ensure "Node LTS" "fnm list | grep -q lts" fnm install --lts
[ "$DRY" = 1 ] || fnm default lts-latest >/dev/null 2>&1 || true
[ "$DRY" = 1 ] || fnm use lts-latest >/dev/null 2>&1 || true

say "Python (uv)"
ensure "Python 3.12 (uv-managed)" "uv python list --only-installed | grep -q 3.12" uv python install 3.12

rust_toolchain
node_globals
git_identity
summary
