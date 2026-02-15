#!/usr/bin/env bash
# Custom Claude Code statusline

MAX_DIR_LENGTH=30

input=$(cat)

# ---- utility functions ----
truncate() {
  local str="$1"
  local max_len="$2"
  local str_len=${#str}

  if [ "$str_len" -le "$max_len" ]; then
    echo "$str"
  else
    local keep=$((max_len - 3))
    local start=$((str_len - keep))
    echo "...${str:$start}"
  fi
}

make_project_relative() {
  local path="$1"
  local expanded_path="${path/#\~/$HOME}"

  if git -C "$expanded_path" rev-parse --show-toplevel >/dev/null 2>&1; then
    local git_root=$(git -C "$expanded_path" rev-parse --show-toplevel 2>/dev/null)
    local project_name=$(basename "$git_root")
    local rel_path="${expanded_path#$git_root}"
    rel_path="${rel_path#/}"

    if [ -n "$rel_path" ]; then
      echo "${project_name}/${rel_path}"
    else
      echo "${project_name}"
    fi
  else
    echo "$(basename "$expanded_path")"
  fi
}

# ---- colors ----
use_color=1
[ -n "$NO_COLOR" ] && use_color=0

rst() { if [ "$use_color" -eq 1 ]; then printf '\033[0m'; fi; }
dir_color() { if [ "$use_color" -eq 1 ]; then printf '\033[38;5;117m'; fi; }
model_color() { if [ "$use_color" -eq 1 ]; then printf '\033[38;5;147m'; fi; }
git_color() { if [ "$use_color" -eq 1 ]; then printf '\033[38;5;150m'; fi; }
git_clean_color() { if [ "$use_color" -eq 1 ]; then printf '\033[38;5;82m'; fi; }
git_dirty_color() { if [ "$use_color" -eq 1 ]; then printf '\033[38;5;208m'; fi; }

# ---- parse input ----
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "unknown"' 2>/dev/null | sed "s|^$HOME|~|g")
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"' 2>/dev/null)
model_version=$(echo "$input" | jq -r '.model.version // empty' 2>/dev/null)

current_dir=$(make_project_relative "$current_dir")
current_dir=$(truncate "$current_dir" "$MAX_DIR_LENGTH")

# ---- git ----
git_branch=""
git_status_indicator=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  git_branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

  if [ -z "$(git status --porcelain 2>/dev/null)" ]; then
    git_status_indicator="✓"
    git_status_color="$(git_clean_color)"
  else
    git_status_indicator="●"
    git_status_color="$(git_dirty_color)"
  fi

  if git rev-parse --abbrev-ref '@{upstream}' >/dev/null 2>&1; then
    read -r behind ahead <<< "$(git rev-list --count --left-right '@{upstream}...HEAD' 2>/dev/null)"
    [ "$ahead" -gt 0 ] 2>/dev/null && git_status_indicator="${git_status_indicator}↑"
    [ "$behind" -gt 0 ] 2>/dev/null && git_status_indicator="${git_status_indicator}↓"
  fi
fi

# ---- render ----
printf '🤖 %s%s' "$(model_color)" "$model_name"
if [ -n "$model_version" ]; then
  printf '  🏷️ %s' "$model_version"
fi
printf '%s  🕐 %s' "$(rst)" "$(date '+%I:%M %p')"

printf '\n📁 %s%s%s' "$(dir_color)" "$current_dir" "$(rst)"
if [ -n "$git_branch" ]; then
  printf '  🌿 %s%s %s%s%s' "$(git_color)" "$git_branch" "$git_status_color" "$git_status_indicator" "$(rst)"
fi
printf '\n'
