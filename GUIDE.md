# Guide: what was installed and what it is for

Each entry: what it is, why it is here, and the one command that proves it works.

## Foundations

**Homebrew** (macOS) · `brew --version`
The package manager for macOS. Every other tool on a Mac is installed and updated through
it. `brew upgrade` updates everything at once.

**Xcode Command Line Tools** (macOS) · `xcode-select -p`
Apple's compilers and `git`. Homebrew needs them; so does anything that compiles.

**build-essential** (Linux) · `gcc --version`
Compilers and headers. Needed by native Node modules, Python packages and Docker builds.

**winget** (Windows) · `winget --version`
Microsoft's package manager. Ships with Windows 11.

## Version control

**git** · `git --version`
The version control system. Every project is a git repository.

**GitHub CLI (`gh`)** · `gh --version`
GitHub from the terminal: `gh repo create`, `gh pr create`, `gh auth login`. Agents use it
to open pull requests.

## JavaScript

**fnm** · `fnm --version`
Fast Node Manager. Installs Node and switches versions per project (`.node-version` or
`.nvmrc`). `fnm install --lts` for the current LTS.

**Node.js (LTS)** · `node --version`
The JavaScript runtime. Astro, Next.js, Remotion, Claude Code and Codex all run on it.

**npm and npx** · `npm --version`
Come with Node. `npm install` adds a project's packages; `npx <tool>` runs a tool without
installing it globally (`npx create-astro@latest`, `npx playwright test`).

**pnpm** · `pnpm --version`
A faster, disk-efficient npm. `pnpm install` in any project. `npm` still works.

**Bun** · `bun --version`
A second JavaScript runtime and bundler, much faster for scripts and tests. `bun run x.ts`.

**TypeScript, tsx** · `tsc --version`, `tsx --version`
The type checker, and `tsx file.ts` to run a TypeScript file directly.

**serve** · `serve --version`
`serve dist` previews any static HTML build on localhost.

**Prettier** · `prettier --version`
Formats JS, TS, CSS, HTML, Markdown, JSON. `prettier --write .`

## Python

**Python 3** · `python3 --version`
Scripts, data, ML, automation.

**uv** · `uv --version`
One tool for Python packages, virtual environments and Python versions. `uv init`,
`uv add requests`, `uv run script.py`. Replaces pip, venv, pipx and pyenv.

## Go and Rust

**Go** · `go version`
Simple, fast, one binary. `go run .` in a project. Many CLIs and servers are written in it.

**Rust** · `cargo --version`
Installed with `rustup`, which also updates it (`rustup update`). `cargo new`, `cargo run`.

## Databases

**PostgreSQL** · `psql --version`
The database. The client (`psql`) talks to any Postgres, local or hosted (Supabase, Neon,
Vercel Postgres). On a Mac `brew services start postgresql@16` runs a local server; on Linux
and Windows use Docker or the installed server.

**SQLite** · `sqlite3 --version`
A database in a single file. `sqlite3 app.db` for anything small or local.

## Containers

**Docker** · `docker --version`
Run Postgres, Redis or any service in a container, identical on every machine.
`docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=dev postgres:16` gives a database in
one line. Desktop app on Mac and Windows, engine on Linux.

## Editor

**Visual Studio Code** · `code --version`
The editor. The `code` command opens a folder from the terminal.

**Google Chrome**
The browser to check work in, and the one Playwright can drive when installed.

## Agents

**Claude Code** · `claude --version`
Anthropic's coding agent, in the terminal. `claude` in a project folder. Reads the code,
edits files, runs commands, opens PRs. `/plugin` and the skills marketplace add skills.

**OpenAI Codex CLI** · `codex --version`
OpenAI's coding agent. `codex` in a project folder. A second opinion and a second pair of
hands.

**Playwright Chromium** · `npx playwright --version`
A headless browser agents can drive: open a page, click, screenshot, run end-to-end tests.
`npx playwright install chromium` fetched the browser; `npx playwright codegen <url>` records
a test.

**Finding skills** · `npx skills find <topic>`
Skills are reusable instruction packs for agents (deploy steps, review checklists,
framework knowledge). `npx skills find` searches the public registry and
`npx skills add <owner/repo>` installs one into the current project.

## Deploy

**Vercel CLI** · `vercel --version`
Deploy from the terminal: `vercel` for a preview, `vercel --prod` for production.

## Search and shell

**ripgrep (`rg`)** · `rg --version` — search code fast. `rg "TODO"`.
**fd** · `fd --version` — find files fast. `fd config`.
**fzf** · `fzf --version` — fuzzy pick anything. `Ctrl-R` for history once wired in.
**jq** · `jq --version` — read and transform JSON. `curl … | jq .`.
**bat** · `bat --version` — `cat` with syntax highlighting.
**eza** · `eza --version` — `ls` with colours, icons and git status.
**tmux** · `tmux -V` — terminal sessions that survive a closed window. Long-running agents
live in tmux.
**curl, wget** — fetch anything.

## Video and photo

**ffmpeg** · `ffmpeg -version`
Convert, trim, resize, extract frames, mux audio. The tool behind every video pipeline.
`ffmpeg -i in.mov -ss 0:05 -t 10 out.mp4` cuts ten seconds; `-frames:v 1` grabs a frame.

**ImageMagick** · `magick --version`
Photos from the terminal: resize, crop, convert, montage. `magick in.png -resize 50% out.webp`.

**exiftool** · `exiftool -ver`
Read and edit metadata: camera, lens, date, GPS. `exiftool photo.jpg`.

**mpv** · `mpv --version`
A fast, minimal video player. `mpv clip.mp4`. Frame-step with `.` and `,`.

**yt-dlp** · `yt-dlp --version`
Fetch a video or audio from almost any site. `yt-dlp <url>`.

**HandBrake**
A GUI for batch transcodes and presets when a one-line ffmpeg is not enough.

In a Node project, `sharp` (`npm i sharp`) does fast image resizing and WebP encoding from
code; it is a project dependency, not a global tool.

## Apps (free)

**Obsidian** — notes as plain Markdown files, with a graph and a canvas.
**OBS Studio** — screen and camera recording, streaming.
**Anki** — spaced-repetition flashcards. Whatever must stay learned.

## Not installed, but next

**Remotion** — video made with React. Nothing to install globally: `npx create-video@latest`
in a new folder.
**Astro / Next.js** — `npm create astro@latest` or `npx create-next-app@latest`.
**Supabase / Postgres** — run Postgres in Docker (above) or `npx supabase init`.
