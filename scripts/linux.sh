#!/usr/bin/env bash
# fullstack-from-scratch — Ubuntu / Debian. apt first, official installers for the rest.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$here/common.sh" "$@"

if ! have apt-get; then echo "This script expects apt (Ubuntu/Debian)." >&2; exit 1; fi
SUDO=""; [ "$(id -u)" = 0 ] || SUDO="sudo"

say "System packages (apt)"
run $SUDO apt-get update -y
run $SUDO apt-get install -y --no-install-recommends \
  build-essential ca-certificates curl wget git gnupg unzip \
  ripgrep fd-find fzf jq bat tmux python3 python3-venv python3-pip \
  ffmpeg imagemagick libimage-exiftool-perl mpv \
  postgresql-client sqlite3 golang-go
INSTALLED+=("apt packages")
# Debian names two of these differently.
[ -e "$HOME/.local/bin/fd" ] || { mkdir -p "$HOME/.local/bin"; ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd" 2>/dev/null || true; }
[ -e "$HOME/.local/bin/bat" ] || { ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat" 2>/dev/null || true; }
rc_line 'export PATH="$HOME/.local/bin:$PATH"'
export PATH="$HOME/.local/bin:$PATH"

say "GitHub CLI"
if have gh; then note "already installed"; SKIPPED+=("gh")
else
  run bash -c "curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | $SUDO dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo 'deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main' | $SUDO tee /etc/apt/sources.list.d/github-cli.list >/dev/null && \
    $SUDO apt-get update -y && $SUDO apt-get install -y gh"
  INSTALLED+=("gh")
fi

say "eza"
ensure "eza" "have eza" bash -c "$SUDO mkdir -p /etc/apt/keyrings && curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | $SUDO gpg --dearmor -o /etc/apt/keyrings/gierens.gpg --yes && echo 'deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main' | $SUDO tee /etc/apt/sources.list.d/gierens.list >/dev/null && $SUDO apt-get update -y && $SUDO apt-get install -y eza"

say "Node (LTS via fnm)"
ensure "fnm" "have fnm || [ -x \$HOME/.local/share/fnm/fnm ]" bash -c "curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell"
export PATH="$HOME/.local/share/fnm:$PATH"
rc_line 'export PATH="$HOME/.local/share/fnm:$PATH"'
rc_line 'eval "$(fnm env --use-on-cd)"'
if [ "$DRY" = 0 ] && have fnm; then eval "$(fnm env)"; fi
ensure "Node LTS" "fnm list 2>/dev/null | grep -q lts" fnm install --lts
[ "$DRY" = 1 ] || fnm default lts-latest >/dev/null 2>&1 || true
[ "$DRY" = 1 ] || fnm use lts-latest >/dev/null 2>&1 || true
ensure "pnpm" "have pnpm" npm install -g pnpm

say "Python (uv)"
ensure "uv" "have uv" bash -c "curl -LsSf https://astral.sh/uv/install.sh | sh"
export PATH="$HOME/.local/bin:$PATH"
ensure "yt-dlp" "have yt-dlp" uv tool install yt-dlp

say "Bun"
ensure "Bun" "have bun || [ -x \$HOME/.bun/bin/bun ]" bash -c "curl -fsSL https://bun.sh/install | bash"
rc_line 'export PATH="$HOME/.bun/bin:$PATH"'
export PATH="$HOME/.bun/bin:$PATH"

rust_toolchain

if [ "$NO_APPS" = 0 ]; then
  say "Docker Engine"
  ensure "Docker" "have docker" bash -c "curl -fsSL https://get.docker.com | $SUDO sh && $SUDO usermod -aG docker \$USER"
  note "log out and in again for docker without sudo"
  say "Visual Studio Code"
  ensure "VS Code" "have code" bash -c "curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | $SUDO gpg --dearmor -o /usr/share/keyrings/microsoft.gpg --yes && echo 'deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main' | $SUDO tee /etc/apt/sources.list.d/vscode.list >/dev/null && $SUDO apt-get update -y && $SUDO apt-get install -y code"
  ensure "HandBrake" "have ghb" bash -c "$SUDO apt-get install -y handbrake"
  ensure "Google Chrome" "have google-chrome" bash -c "curl -fsSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb && $SUDO apt-get install -y /tmp/chrome.deb && rm /tmp/chrome.deb"
  note "Obsidian, OBS and Anki: install from their sites (AppImage / Flatpak / apt) — see GUIDE.md"
fi

node_globals
git_identity
summary
