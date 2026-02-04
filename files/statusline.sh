#!/usr/bin/env bash
# Custom Claude Code statusline
STATUSLINE_VERSION="3.0.0"

# ---- Configuration ----
SHOW_GIT_STATUS=true       # Show ✓/● git clean/dirty indicator
SHOW_MODEL_VERSION=true    # Show model version number
SHOW_TIME=true             # Show current time

# Display settings
MAX_DIR_LENGTH=30          # Max chars for directory path

input=$(cat)

# Get the directory where this statusline script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/statusline.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# ---- check jq availability ----
HAS_JQ=0
if command -v jq >/dev/null 2>&1; then
  HAS_JQ=1
fi

# ---- logging ----
{
  echo "[$TIMESTAMP] Status line triggered (cc-statusline v${STATUSLINE_VERSION})"
  echo "[$TIMESTAMP] Input:"
  if [ "$HAS_JQ" -eq 1 ]; then
    echo "$input" | jq . 2>/dev/null || echo "$input"
    echo "[$TIMESTAMP] Using jq for JSON parsing"
  else
    echo "$input"
    echo "[$TIMESTAMP] WARNING: jq not found, using bash fallback for JSON parsing"
  fi
  echo "---"
} >> "$LOG_FILE" 2>/dev/null

# ---- utility functions ----
# Truncate string with ellipsis, preserving end (most important for paths)
truncate() {
  local str="$1"
  local max_len="$2"
  local str_len=${#str}

  if [ "$str_len" -le "$max_len" ]; then
    echo "$str"
  else
    # Keep the end of the string (most important for paths like ~/project/subdir)
    local keep=$((max_len - 3))
    local start=$((str_len - keep))
    echo "...${str:$start}"
  fi
}

# Make path relative to project root
# Example: ~/dev/website-monorepo/internal/app -> website-monorepo/internal/app
make_project_relative() {
  local path="$1"

  # Expand ~ to $HOME for processing
  local expanded_path="${path/#\~/$HOME}"

  # If in a git repo, use git root as project root
  if git -C "$expanded_path" rev-parse --show-toplevel >/dev/null 2>&1; then
    local git_root=$(git -C "$expanded_path" rev-parse --show-toplevel 2>/dev/null)
    local project_name=$(basename "$git_root")

    # Get relative path from git root
    local rel_path="${expanded_path#$git_root}"
    rel_path="${rel_path#/}"  # Remove leading slash

    # Combine project name with relative path
    if [ -n "$rel_path" ]; then
      echo "${project_name}/${rel_path}"
    else
      echo "${project_name}"
    fi
  else
    # Not in a git repo, just return the basename
    echo "$(basename "$expanded_path")"
  fi
}

# ---- color helpers ----
use_color=1
[ -n "$NO_COLOR" ] && use_color=0

rst() { if [ "$use_color" -eq 1 ]; then printf '\033[0m'; fi; }

# ---- colors ----
dir_color() { if [ "$use_color" -eq 1 ]; then printf '\033[38;5;117m'; fi; }    # sky blue
model_color() { if [ "$use_color" -eq 1 ]; then printf '\033[38;5;147m'; fi; }  # light purple
git_color() { if [ "$use_color" -eq 1 ]; then printf '\033[38;5;150m'; fi; }    # soft green
git_clean_color() { if [ "$use_color" -eq 1 ]; then printf '\033[38;5;82m'; fi; }   # bright green
git_dirty_color() { if [ "$use_color" -eq 1 ]; then printf '\033[38;5;208m'; fi; }  # orange

# ---- basics ----
if [ "$HAS_JQ" -eq 1 ]; then
  current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "unknown"' 2>/dev/null | sed "s|^$HOME|~|g")
  model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"' 2>/dev/null)
  model_version=$(echo "$input" | jq -r '.model.version // ""' 2>/dev/null)
else
  # Bash fallback for JSON extraction
  current_dir=$(echo "$input" | grep -o '"workspace"[[:space:]]*:[[:space:]]*{[^}]*"current_dir"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"current_dir"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' | sed 's/\\\\/\//g')

  # Fall back to cwd if workspace extraction failed
  if [ -z "$current_dir" ] || [ "$current_dir" = "null" ]; then
    current_dir=$(echo "$input" | grep -o '"cwd"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' | sed 's/\\\\/\//g')
  fi

  [ -z "$current_dir" ] && current_dir="unknown"
  current_dir=$(echo "$current_dir" | sed "s|^$HOME|~|g")

  model_name=$(echo "$input" | grep -o '"model"[[:space:]]*:[[:space:]]*{[^}]*"display_name"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"display_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
  [ -z "$model_name" ] && model_name="Claude"
  model_version=""
fi

# Make path relative to project root, then truncate if needed
current_dir=$(make_project_relative "$current_dir")
current_dir=$(truncate "$current_dir" "$MAX_DIR_LENGTH")

# ---- git ----
git_branch=""
git_status_indicator=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  git_branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

  # Check if repo is clean or dirty (only if feature enabled)
  if [ "$SHOW_GIT_STATUS" = true ]; then
    if [ -z "$(git status --porcelain 2>/dev/null)" ]; then
      git_status_indicator="✓"  # clean
    else
      git_status_indicator="●"  # dirty (uncommitted changes)
    fi
  fi
fi

# ---- log extracted data ----
{
  echo "[$TIMESTAMP] Extracted: dir=${current_dir:-}, model=${model_name:-}, git=${git_branch:-} ${git_status_indicator:-}"
} >> "$LOG_FILE" 2>/dev/null

# ---- render statusline ----
# Line 1: Model and current time
printf '🤖 %s%s' "$(model_color)" "$model_name"
if [ "$SHOW_MODEL_VERSION" = true ] && [ -n "$model_version" ] && [ "$model_version" != "null" ]; then
  printf '  🏷️ %s' "$model_version"
fi
printf '%s' "$(rst)"
if [ "$SHOW_TIME" = true ]; then
  current_time=$(date '+%I:%M %p')
  printf '  🕐 %s' "$current_time"
fi

# Line 2: Directory and git
printf '\n📁 %s%s%s' "$(dir_color)" "$current_dir" "$(rst)"
if [ -n "$git_branch" ]; then
  printf '  🌿 %s%s' "$(git_color)" "$git_branch"
  if [ "$SHOW_GIT_STATUS" = true ] && [ -n "$git_status_indicator" ]; then
    if [ "$git_status_indicator" = "✓" ]; then
      printf ' %s%s' "$(git_clean_color)" "$git_status_indicator"
    else
      printf ' %s%s' "$(git_dirty_color)" "$git_status_indicator"
    fi
  fi
  printf '%s' "$(rst)"
fi
printf '\n'
