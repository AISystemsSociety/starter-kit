# AI Systems Society Starter Kit

One command installs everything: skills, templates, and Context Guardian for Claude Code.

## Install

Open your terminal and paste:

```bash
bash <(curl -s https://raw.githubusercontent.com/AISystemsSociety/starter-kit/main/install.sh)
```

The installer will:
1. Check if you have Git and GitHub CLI installed (guides you through setup if not)
2. Download all skills to `~/.claude/skills/`
3. Download the growth plan deck template to `~/.claude/templates/growth-plan-deck/`
4. Install Context Guardian (prevents context death in Claude Code)
5. Create a reference guide showing how to use everything

## What You Get

### Skills (AI Prompts)

| Skill | What It Does |
|-------|-------------|
| **$100M Offer Builder** | Interactive prompt that interviews you about your business, then builds a complete cold-traffic offer using Hormozi, Brunson, Schwartz, and 3 other frameworks. Includes sales call scripts, retainer design, and disqualification criteria. Paste into Claude or ChatGPT. |
| **YouTube Script Framework** | Plan any YouTube video using Hormozi's Proof/Promise/Path structure. Hook formulas, section breakdowns, thumbnail concepts, B-roll checklists. |
| **Podcast Guest Research** | Deep-research framework for podcast guests. 10-question interview structure in 5 arcs, scoring system, gap analysis, off-air transition scripts. |
| **Growth Plan Deck** | A guided build for a 20-slide growth plan deck. Interviews you about your offer, your prospect and your numbers, then fills the deck in and checks it. |
| **GitHub for Agencies** | Complete GitHub guide for non-technical service business owners. Setup, daily workflow, hosting, password protection. |

### Templates

| Template | What It Is |
|----------|-----------|
| **Growth Plan Deck** | 20-slide HTML presentation. Dark theme, animations, keyboard and swipe navigation, mobile responsive. Single file, zero dependencies. Ships with the design system, the reasoning behind every slide, and the rules it is checked against. |

### Tools

| Tool | What It Does |
|------|-------------|
| **Context Guardian** | Hook-based system that counts tool calls, warns at thresholds, and hard-blocks at 65 calls to force a save. Prevents losing work when Claude Code's context fills up. Auto-saves and auto-restores across sessions. |

## After Installing

**1. Restart Claude Code** to activate Context Guardian.

**2. Try a skill.** Open Claude Code and type:
```
Load ~/.claude/skills/100m-offer-builder.md and build an offer for my business
```

**3. Build a pitch deck.** Copy the template to a project folder:
```bash
cd ~/.claude/templates/growth-plan-deck && cat CUSTOMIZE.md
```
Then open Claude Code in that folder and say: "Help me customize this deck for [prospect name]"

**4. Add skills to your CLAUDE.md** (optional). Run `cat ~/.claude/skills/claude-md-snippet.md` to see the snippet you can paste into any project's CLAUDE.md.

## Requirements

- **Claude Code** (Anthropic's CLI tool)
- **macOS or Linux** (Windows users: use Git Bash, not PowerShell)
- **Git** (the installer checks and guides you if missing)
- **GitHub CLI** (optional, needed for deploying to GitHub Pages)

## Update

Re-run the install command to pull the latest versions of all skills:
```bash
bash <(curl -s https://raw.githubusercontent.com/AISystemsSociety/starter-kit/main/install.sh)
```
It will overwrite existing files with the latest versions.

## Community

Join the AI Systems Society on Skool: https://www.skool.com/aisystems
