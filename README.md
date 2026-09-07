# fullstack-from-scratch

One repo, one script: a full-stack, agent-ready development machine from nothing.

Clone it on a fresh Mac, Linux or Windows machine, run the setup, and you get every
language, tool, package and agent CLI needed to build software with AI agents, starting
from the very first thing (Homebrew on a Mac, `apt` on Linux, `winget` on Windows).
At the end it prints what it installed and why, and [GUIDE.md](GUIDE.md) explains each
piece.

Everything is idempotent. Run it again any time; it only installs what is missing.

## Quick start

**macOS**

```sh
git clone https://github.com/mi1kandcookies/fullstack-from-scratch.git
cd fullstack-from-scratch
./setup.sh
```

**Linux** (Ubuntu / Debian)

```sh
git clone https://github.com/mi1kandcookies/fullstack-from-scratch.git
cd fullstack-from-scratch
./setup.sh
```

**Windows** (PowerShell, run as your normal user)

```powershell
git clone https://github.com/mi1kandcookies/fullstack-from-scratch.git
cd fullstack-from-scratch
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows.ps1
```

`git` may not exist yet on a brand-new machine. On a Mac, `./setup.sh` is not needed
for that: run `xcode-select --install` first, or download the repo as a zip. On
Windows, install Git with `winget install Git.Git` first, then clone.

## What you get

| Layer | What | Why |
|---|---|---|
| Package manager | Homebrew / apt / winget | Everything below comes from here, and can be updated from here. |
| Version control | git, GitHub CLI (`gh`) | Commit, branch, open PRs, clone private repos, all from the terminal. |
| JavaScript | Node LTS via `fnm`, `pnpm` | The web runs on it. `fnm` switches Node versions per project. |
| Python | Python 3, `uv` | Scripts, data work, ML. `uv` replaces pip, venv and pyenv in one fast tool. |
| Containers | Docker | Databases and services in a box, identical on every machine. |
| Editor | Visual Studio Code | The editor the agents work inside. |
| Agents | Claude Code, OpenAI Codex CLI | The coding agents. Claude Code is the primary one. |
| Deploy | Vercel CLI | Ship a site from the terminal. |
| Search & shell | ripgrep, fd, fzf, jq, bat, eza, tmux | Fast search and a comfortable terminal. Agents use these too. |
| Media | ffmpeg | Every video and audio task, from thumbnails to transcodes. |
| Apps | Obsidian, OBS Studio, Anki | Notes, recording, memory. Free. |

See [GUIDE.md](GUIDE.md) for each tool: what it is, what it is for, and how to check it
works.

## Options

```sh
./setup.sh --no-apps      # skip the desktop apps (Obsidian, OBS, Anki, VS Code, Docker Desktop)
./setup.sh --no-agents    # skip Claude Code and Codex
./setup.sh --dry-run      # print what would be installed, install nothing
```

The Windows script takes the same flags: `.\scripts\windows.ps1 -NoApps -NoAgents -DryRun`.

## After it runs

1. Open a new terminal so the new PATH entries load.
2. `gh auth login` to connect GitHub.
3. `claude` to start Claude Code and sign in. `codex` for Codex.
4. `git config --global user.name` and `user.email` if the script did not set them.

## What it does not do

It does not sign you in to anything, does not touch your dotfiles beyond adding PATH
lines for `fnm`, `uv` and `pnpm`, and does not install databases natively (use Docker).

## Updating

```sh
git pull && ./setup.sh
```
