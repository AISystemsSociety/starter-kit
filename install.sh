#!/bin/bash
# AI Systems Society Starter Kit Installer
# Downloads all skills and sets up your Claude Code environment
#
# Usage: bash <(curl -s https://raw.githubusercontent.com/AISystemsSociety/starter-kit/main/install.sh)

set -e

SKILLS_DIR="$HOME/.claude/skills"
CLAUDE_DIR="$HOME/.claude"
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${CYAN}${BOLD}AI Systems Society Starter Kit${NC}"
echo -e "${CYAN}Setting up your Claude Code environment...${NC}"
echo ""

# ============================================================
# STEP 0: Check prerequisites
# ============================================================

MISSING=""

# Check for curl
if ! command -v curl &>/dev/null; then
  echo -e "${RED}curl is not installed.${NC}"
  echo "  Mac: it should be pre-installed. Try: xcode-select --install"
  echo "  Windows: install Git for Windows (includes curl): https://git-scm.com/download/win"
  MISSING="yes"
fi

# Check for git
if ! command -v git &>/dev/null; then
  echo ""
  echo -e "${YELLOW}${BOLD}Git is not installed.${NC}"
  echo ""
  echo "  Git tracks changes to your files and lets you push code to GitHub."
  echo "  You need it for Context Guardian and for deploying projects."
  echo ""
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "  To install on Mac, run this in your terminal:"
    echo -e "    ${BOLD}xcode-select --install${NC}"
    echo ""
    echo "  A popup will appear. Click 'Install', wait for it to finish, then re-run this script."
  else
    echo "  To install on Windows:"
    echo "    Download from: https://git-scm.com/download/win"
    echo "    Run the installer with default settings."
    echo "    Then re-run this script in Git Bash (not PowerShell)."
  fi
  MISSING="yes"
fi

# Check for GitHub CLI (gh)
if ! command -v gh &>/dev/null; then
  echo ""
  echo -e "${YELLOW}${BOLD}GitHub CLI (gh) is not installed.${NC}"
  echo ""
  echo "  The GitHub CLI lets you create repos and deploy sites from your terminal."
  echo "  It's optional for skills, but required if you want to deploy projects."
  echo ""
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew &>/dev/null; then
      echo "  To install on Mac (you have Homebrew):"
      echo -e "    ${BOLD}brew install gh${NC}"
    else
      echo "  To install on Mac:"
      echo "    First install Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
      echo -e "    Then: ${BOLD}brew install gh${NC}"
    fi
  else
    echo "  To install on Windows:"
    echo -e "    ${BOLD}winget install GitHub.cli${NC}"
  fi
  echo ""
  echo "  After installing, authenticate:"
  echo -e "    ${BOLD}gh auth login${NC}"
  echo "    Choose: GitHub.com > HTTPS > Login with a web browser"
  echo ""
  echo -e "  ${CYAN}Skills will still install without gh. You just won't be able to push to GitHub yet.${NC}"
fi

# Check for GitHub account
if command -v gh &>/dev/null; then
  if ! gh auth status &>/dev/null 2>&1; then
    echo ""
    echo -e "${YELLOW}GitHub CLI is installed but not logged in.${NC}"
    echo ""
    echo "  Run this to log in:"
    echo -e "    ${BOLD}gh auth login${NC}"
    echo "    Choose: GitHub.com > HTTPS > Login with a web browser"
    echo ""
    echo -e "  ${CYAN}Don't have a GitHub account? Create one at: https://github.com/signup${NC}"
    echo "  Use your business email. Pick a professional username, clients might see it."
  fi
fi

# If curl or git is missing, we can't continue
if [ -n "$MISSING" ]; then
  echo ""
  echo -e "${RED}Install the missing tools above, then re-run this script.${NC}"
  exit 1
fi

echo -e "${GREEN}Prerequisites OK${NC}"
echo ""

# ============================================================
# STEP 1: Create directories
# ============================================================

mkdir -p "$SKILLS_DIR"
mkdir -p "$CLAUDE_DIR"

echo -e "${GREEN}[1/5]${NC} Downloading skills..."

# Download each skill file
curl -sL "https://raw.githubusercontent.com/AISystemsSociety/100m-offer-builder/main/100m-offer-builder.md" \
  -o "$SKILLS_DIR/100m-offer-builder.md"
echo "  → 100M Offer Builder (includes Grand Slam Offer Architect)"

curl -sL "https://raw.githubusercontent.com/AISystemsSociety/youtube-script-framework/main/youtube-script-framework.md" \
  -o "$SKILLS_DIR/youtube-script-framework.md"
echo "  → YouTube Script Framework"

curl -sL "https://raw.githubusercontent.com/AISystemsSociety/podcast-guest-research/main/podcast-guest-research.md" \
  -o "$SKILLS_DIR/podcast-guest-research.md"
echo "  → Podcast Guest Research"

curl -sL "https://raw.githubusercontent.com/AISystemsSociety/github-for-agencies/main/github-for-agencies.md" \
  -o "$SKILLS_DIR/github-for-agencies.md"
echo "  → GitHub for Agencies"

echo ""
echo -e "${GREEN}[2/5]${NC} Downloading templates..."

TEMPLATES_DIR="$HOME/.claude/templates"
mkdir -p "$TEMPLATES_DIR"

# The growth plan deck is a folder now: the template, a build script, and the docs.
# Cloning keeps build.py next to the template it expects, which curling file by file does not.
DECK_DIR="$TEMPLATES_DIR/growth-plan-deck"
if [ -d "$DECK_DIR/.git" ]; then
  git -C "$DECK_DIR" pull --quiet --ff-only 2>/dev/null || true
else
  rm -rf "$DECK_DIR"
  git clone --quiet --depth 1 \
    https://github.com/AISystemsSociety/growth-plan-deck-template.git "$DECK_DIR"
fi
echo "  → Growth Plan Deck Template (20 slides, docs, build script)"

cp "$DECK_DIR/SKILL.md" "$SKILLS_DIR/growth-plan-deck.md"
echo "  → Growth Plan Deck Skill (guided build)"

echo ""
echo -e "${GREEN}[3/5]${NC} Installing Context Guardian..."

SCRIPTS_DIR="$HOME/.claude/scripts"
CHECKPOINTS_DIR="$HOME/.claude/checkpoints"
mkdir -p "$SCRIPTS_DIR"
mkdir -p "$CHECKPOINTS_DIR"

# Clone context guardian to temp, copy scripts, clean up
CG_TMP=$(mktemp -d)
git clone -q https://github.com/AISystemsSociety/context-guardian.git "$CG_TMP" 2>/dev/null
cp "$CG_TMP/scripts/"*.sh "$SCRIPTS_DIR/"
chmod +x "$SCRIPTS_DIR/context-guardian.sh"
chmod +x "$SCRIPTS_DIR/context-gate.sh"
chmod +x "$SCRIPTS_DIR/session-resume.sh"
chmod +x "$SCRIPTS_DIR/compact-reload.sh"
echo "0" > "$HOME/.claude/.tool-counter"

# Copy CLAUDE.md snippet for reference
cp "$CG_TMP/claudemd-snippet.md" "$SKILLS_DIR/context-guardian-setup.md"
echo "  → Context Guardian scripts installed"
echo "  → Tool counter initialized"

# Check if settings.json needs hooks
SETTINGS_FILE="$HOME/.claude/settings.json"
if [ ! -f "$SETTINGS_FILE" ]; then
  cp "$CG_TMP/settings-template.json" "$SETTINGS_FILE"
  echo "  → Created settings.json with Context Guardian hooks"
else
  echo -e "  → ${YELLOW}settings.json already exists, merge the hooks manually${NC}"
  echo "    See: $SKILLS_DIR/context-guardian-setup.md"
fi

rm -rf "$CG_TMP"

echo ""
echo -e "${GREEN}[4/5]${NC} Setting up CLAUDE.md snippet..."

SNIPPET_FILE="$SKILLS_DIR/claude-md-snippet.md"
cat > "$SNIPPET_FILE" << 'SNIPPET'
# AI Systems Society Skills

## Available Skills

Load these skills by referencing them in your prompts or CLAUDE.md:

| Skill | File | Use When |
|-------|------|----------|
| $100M Offer Builder | `~/.claude/skills/100m-offer-builder.md` | Building a new service offer from scratch |
| YouTube Script Framework | `~/.claude/skills/youtube-script-framework.md` | Planning a YouTube video with Proof/Promise/Path |
| Podcast Guest Research | `~/.claude/skills/podcast-guest-research.md` | Prepping for a podcast guest interview |
| Growth Plan Deck | `~/.claude/skills/growth-plan-deck.md` | Building a 20-slide growth plan deck for a prospect |
| GitHub for Agencies | `~/.claude/skills/github-for-agencies.md` | Setting up repos, deploying, managing code |
| Context Guardian | `~/.claude/skills/context-guardian-setup.md` | Preventing context death in long sessions |

## How to Use Skills

**Option 1, reference it in your prompt:**
"Load the skill at ~/.claude/skills/100m-offer-builder.md and run me through the offer builder for my business."

**Option 2, add it to your CLAUDE.md:**
Add the skill table above to your project's CLAUDE.md file. Claude will see it at the start of every session.

**Option 3, use the growth plan deck:**
Everything lives in `~/.claude/templates/growth-plan-deck/`. Point Claude at its `SKILL.md` and it interviews you, then fills the deck in. `CUSTOMIZE.md` covers doing it by hand, and `docs/` explains the design system, why each slide exists, and the rules the deck is checked against.

## Context Guardian

Context Guardian prevents Claude Code from losing your work when the context window fills up. It's already installed. To activate:

1. If you had no `settings.json` before, it is already configured, just restart Claude Code.
2. If you had an existing `settings.json`, merge the hooks from `~/.claude/skills/context-guardian-setup.md`.

What it does:
- Counts every tool call in your session
- Warns you at 25/40/55 calls
- Hard-blocks expensive tools at 65 calls (forces you to save and /compact)
- Auto-saves and auto-restores checkpoints across /compact and session restarts
SNIPPET

echo "  → Created skill reference guide at $SNIPPET_FILE"

echo ""
echo -e "${GREEN}[5/5]${NC} Verifying installation..."

# Count installed files
SKILL_COUNT=$(ls "$SKILLS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
SCRIPT_COUNT=$(ls "$SCRIPTS_DIR"/*.sh 2>/dev/null | wc -l | tr -d ' ')
TEMPLATE_COUNT=$(ls "$TEMPLATES_DIR"/*.html 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo -e "${CYAN}${BOLD}════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}  Installation Complete${NC}"
echo -e "${CYAN}${BOLD}════════════════════════════════════════${NC}"
echo ""
echo -e "  ${BOLD}Skills installed:${NC}    $SKILL_COUNT files in ~/.claude/skills/"
echo -e "  ${BOLD}Scripts installed:${NC}   $SCRIPT_COUNT files in ~/.claude/scripts/"
echo -e "  ${BOLD}Templates installed:${NC} $TEMPLATE_COUNT files in ~/.claude/templates/"
echo ""
echo -e "${BOLD}  What to do next:${NC}"
echo ""
echo "  1. Restart Claude Code to activate Context Guardian"
echo ""
echo "  2. Add skills to your CLAUDE.md (optional but recommended):"
echo "     cat ~/.claude/skills/claude-md-snippet.md"
echo ""
echo "  3. Try a skill:"
echo "     'Load ~/.claude/skills/100m-offer-builder.md and build an offer for my business'"
echo ""
echo "  4. Build a pitch deck:"
echo "     cd ~/.claude/templates/growth-plan-deck && cat CUSTOMIZE.md"
echo "     'Help me customize this deck for [prospect name]'"
echo ""
echo -e "${CYAN}  Join the community: https://www.skool.com/aisystems${NC}"
echo ""
