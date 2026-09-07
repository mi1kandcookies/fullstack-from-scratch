# fullstack-from-scratch — Windows 11. winget first, then everything through it.
#   Set-ExecutionPolicy -Scope Process Bypass; .\scripts\windows.ps1 [-NoApps] [-NoAgents] [-DryRun]
param([switch]$NoApps, [switch]$NoAgents, [switch]$DryRun)
$ErrorActionPreference = 'Stop'
$installed = @(); $skipped = @()

function Say($t) { Write-Host "`n$t" -ForegroundColor White }
function Note($t) { Write-Host "  $t" }
function Have($c) { return [bool](Get-Command $c -ErrorAction SilentlyContinue) }
function Winget-Ensure($name, $id, $check) {
  if (& $check) { $script:skipped += $name; Note "${name}: already installed"; return }
  Note "${name}: installing"
  if ($DryRun) { Note "would run: winget install --id $id" }
  else { winget install --id $id --exact --silent --accept-package-agreements --accept-source-agreements | Out-Null }
  $script:installed += $name
}

if (-not (Have winget)) { throw "winget is missing. Install 'App Installer' from the Microsoft Store, then re-run." }

Say "Version control"
Winget-Ensure "git" "Git.Git" { Have git }
Winget-Ensure "GitHub CLI" "GitHub.cli" { Have gh }

Say "Languages and managers"
Winget-Ensure "fnm" "Schniz.fnm" { Have fnm }
Winget-Ensure "uv" "astral-sh.uv" { Have uv }
Winget-Ensure "Python 3.12" "Python.Python.3.12" { Have python }
Winget-Ensure "Go" "GoLang.Go" { Have go }
Winget-Ensure "Rust (rustup)" "Rustlang.Rustup" { Have cargo }
Winget-Ensure "Bun" "Oven-sh.Bun" { Have bun }
Winget-Ensure "PostgreSQL 16" "PostgreSQL.PostgreSQL.16" { Have psql }
Winget-Ensure "SQLite" "SQLite.SQLite" { Have sqlite3 }

Say "Search and shell"
Winget-Ensure "ripgrep" "BurntSushi.ripgrep.MSVC" { Have rg }
Winget-Ensure "fd" "sharkdp.fd" { Have fd }
Winget-Ensure "fzf" "junegunn.fzf" { Have fzf }
Winget-Ensure "jq" "jqlang.jq" { Have jq }
Winget-Ensure "bat" "sharkdp.bat" { Have bat }
Winget-Ensure "eza" "eza-community.eza" { Have eza }
Winget-Ensure "PowerShell 7" "Microsoft.PowerShell" { Have pwsh }
Winget-Ensure "Windows Terminal" "Microsoft.WindowsTerminal" { Have wt }

Say "Media"
Winget-Ensure "ffmpeg" "Gyan.FFmpeg" { Have ffmpeg }
Winget-Ensure "ImageMagick" "ImageMagick.ImageMagick" { Have magick }
Winget-Ensure "ExifTool" "OliverBetz.ExifTool" { Have exiftool }
Winget-Ensure "mpv" "shinchiro.mpv" { Have mpv }
Winget-Ensure "yt-dlp" "yt-dlp.yt-dlp" { Have yt-dlp }

if (-not $NoApps) {
  Say "Apps"
  Winget-Ensure "Visual Studio Code" "Microsoft.VisualStudioCode" { Have code }
  Winget-Ensure "Docker Desktop" "Docker.DockerDesktop" { Have docker }
  Winget-Ensure "Obsidian" "Obsidian.Obsidian" { Test-Path "$env:LOCALAPPDATA\Programs\Obsidian" }
  Winget-Ensure "OBS Studio" "OBSProject.OBSStudio" { Test-Path "$env:ProgramFiles\obs-studio" }
  Winget-Ensure "Anki" "Anki.Anki" { Test-Path "$env:ProgramFiles\Anki" }
  Winget-Ensure "HandBrake" "HandBrake.HandBrake" { Test-Path "$env:ProgramFiles\HandBrake" }
  Winget-Ensure "Google Chrome" "Google.Chrome" { Test-Path "$env:ProgramFiles\Google\Chrome" }
}

# Refresh PATH for this session so fnm/npm are usable below.
$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')

Say "Node (LTS via fnm)"
if (Have fnm) {
  if (-not $DryRun) {
    fnm env --use-on-cd --shell power-shell | Out-String | Invoke-Expression
    if (-not (fnm list | Select-String lts)) { fnm install --lts; $installed += "Node LTS" } else { $skipped += "Node LTS" }
    fnm default lts-latest 2>$null; fnm use lts-latest 2>$null
    $profileLine = 'fnm env --use-on-cd --shell power-shell | Out-String | Invoke-Expression'
    if (-not (Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force | Out-Null }
    if (-not (Select-String -Path $PROFILE -Pattern 'fnm env' -Quiet)) { Add-Content $PROFILE $profileLine }
  } else { Note "would run: fnm install --lts" }
}
if (Have npm) {
  if (-not (Have pnpm)) { if (-not $DryRun) { npm install -g pnpm }; $installed += "pnpm" } else { $skipped += "pnpm" }
  Say "Agent CLIs and deploy"
  if (-not $NoAgents) {
    if (-not (Have claude)) { if (-not $DryRun) { npm install -g @anthropic-ai/claude-code }; $installed += "Claude Code" } else { $skipped += "Claude Code" }
    if (-not (Have codex))  { if (-not $DryRun) { npm install -g @openai/codex }; $installed += "OpenAI Codex CLI" } else { $skipped += "OpenAI Codex CLI" }
  }
  if (-not (Have vercel)) { if (-not $DryRun) { npm install -g vercel }; $installed += "Vercel CLI" } else { $skipped += "Vercel CLI" }
  Say "Node tooling"
  foreach ($t in @(@("tsc","typescript","TypeScript"), @("tsx","tsx","tsx"), @("serve","serve","serve"), @("prettier","prettier","Prettier"))) {
    if (-not (Have $t[0])) { if (-not $DryRun) { npm install -g $t[1] }; $installed += $t[2] } else { $skipped += $t[2] }
  }
  if (-not $NoAgents) { Say "Playwright (Chromium for agents)"; if (-not $DryRun) { npx --yes playwright install chromium }; $installed += "Playwright Chromium" }
}

Say "Done."
if ($installed.Count) { Note ("Installed: " + ($installed -join ", ")) }
if ($skipped.Count)   { Note ("Already there: " + ($skipped -join ", ")) }
Say "Next"
Note "1. Open a new terminal so PATH changes load."
Note "2. gh auth login          — connect GitHub"
Note "3. claude                 — start Claude Code and sign in"
Note "4. Read GUIDE.md for what each tool is and what it is for."
