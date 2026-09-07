# Shared helpers for mac.sh and linux.sh. Sourced, not run.

NO_APPS=0; NO_AGENTS=0; DRY=0
for arg in "$@"; do
  case "$arg" in
    --no-apps) NO_APPS=1 ;;
    --no-agents) NO_AGENTS=1 ;;
    --dry-run) DRY=1 ;;
    -h|--help) echo "usage: setup.sh [--no-apps] [--no-agents] [--dry-run]"; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 1 ;;
  esac
done

INSTALLED=(); SKIPPED=()
say()  { printf '\n\033[1m%s\033[0m\n' "$*"; }
note() { printf '  %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }
run()  { if [ "$DRY" = 1 ]; then note "would run: $*"; else "$@"; fi; }

# ensure <name> <check-command> <install-command...>
ensure() {
  local name="$1" check="$2"; shift 2
  if eval "$check" >/dev/null 2>&1; then
    SKIPPED+=("$name"); note "$name: already installed"
  else
    note "$name: installing"; run "$@"; INSTALLED+=("$name")
  fi
}

# Add a line to the shell rc files once.
rc_line() {
  local line="$1"
  for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
    [ -f "$rc" ] || continue
    grep -qF -- "$line" "$rc" || { [ "$DRY" = 1 ] || echo "$line" >> "$rc"; }
  done
}

node_globals() {
  say "Agent CLIs and deploy"
  if [ "$NO_AGENTS" = 0 ]; then
    ensure "Claude Code" "have claude" npm install -g @anthropic-ai/claude-code
    ensure "OpenAI Codex CLI" "have codex" npm install -g @openai/codex
  fi
  ensure "Vercel CLI" "have vercel" npm install -g vercel
}

git_identity() {
  say "Git identity"
  if ! git config --global user.name >/dev/null 2>&1; then
    if [ "$DRY" = 1 ] || [ ! -t 0 ]; then note "git user.name not set — run: git config --global user.name \"Your Name\""; else
      read -rp "  git user.name: " gname; [ -n "$gname" ] && git config --global user.name "$gname"; fi
  fi
  if ! git config --global user.email >/dev/null 2>&1; then
    if [ "$DRY" = 1 ] || [ ! -t 0 ]; then note "git user.email not set — run: git config --global user.email you@example.com"; else
      read -rp "  git user.email: " gmail; [ -n "$gmail" ] && git config --global user.email "$gmail"; fi
  fi
  run git config --global init.defaultBranch main
}

summary() {
  say "Done."
  if [ ${#INSTALLED[@]} -gt 0 ]; then
    note "Installed: ${INSTALLED[*]}"
  fi
  if [ ${#SKIPPED[@]} -gt 0 ]; then
    note "Already there: ${SKIPPED[*]}"
  fi
  say "Versions"
  for c in git gh node pnpm python3 uv docker code claude codex vercel rg fd fzf jq ffmpeg tmux; do
    if have "$c"; then printf '  %-8s %s\n' "$c" "$($c --version 2>/dev/null | head -1 | cut -c1-60)"; fi
  done
  say "Next"
  note "1. Open a new terminal so PATH changes load."
  note "2. gh auth login          — connect GitHub"
  note "3. claude                 — start Claude Code and sign in"
  note "4. Read GUIDE.md for what each tool is and what it is for."
}
