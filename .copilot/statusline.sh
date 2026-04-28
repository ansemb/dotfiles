#!/usr/bin/env bash
# GitHub Copilot CLI status line — Catppuccin Mocha palette
# Reads JSON session data from stdin, prints formatted status line.

set -euo pipefail

DATA=$(cat)

# --- Catppuccin Mocha true-color helpers ---
c() { printf '\033[38;2;%d;%d;%dm' "$1" "$2" "$3"; }
RST='\033[0m'
DIM='\033[2m'

MAUVE=$(c 203 166 247)    # #cba6f7
BLUE=$(c 137 180 250)     # #89b4fa
GREEN=$(c 166 227 161)    # #a6e3a1
PEACH=$(c 250 179 135)    # #fab387
YELLOW=$(c 249 226 175)   # #f9e2af
TEAL=$(c 148 226 213)     # #94e2d5
SUBTEXT=$(c 166 173 200)  # #a6adc8
SURFACE=$(c 88 91 112)    # #585b70

SEP="${DIM}${SURFACE} │ ${RST}"

# --- Extract fields with jq (null-safe) ---
model=$(echo "$DATA" | jq -r '.model.display_name // .model.id // empty')
premium_requests=$(echo "$DATA" | jq -r '.cost.total_premium_requests // empty')
duration_ms=$(echo "$DATA" | jq -r '.cost.total_duration_ms // empty')
ctx_pct=$(echo "$DATA" | jq -r '.context_window.current_context_used_percentage // .context_window.used_percentage // empty')
current_tok=$(echo "$DATA" | jq -r '.context_window.current_context_tokens // empty')
total_tok=$(echo "$DATA" | jq -r '.context_window.total_tokens // empty')
lines_added=$(echo "$DATA" | jq -r '.cost.total_lines_added // empty')
lines_removed=$(echo "$DATA" | jq -r '.cost.total_lines_removed // empty')

# --- Repo / branch ---
repo_branch=""
if git rev-parse --is-inside-work-tree &>/dev/null; then
  repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || echo "")
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo "")
  if [[ -n "$repo" && -n "$branch" ]]; then
    repo_branch="${BLUE}${repo}${RST}${DIM}:${RST}${MAUVE}${branch}${RST}"
  fi
fi

# --- Model ---
model_str=""
if [[ -n "$model" ]]; then
  model_str="${GREEN}${model}${RST}"
fi

# --- Premium requests ---
premium_str=""
if [[ -n "$premium_requests" && "$premium_requests" != "0" ]]; then
  premium_str="${PEACH}${premium_requests} premium${RST}"
fi

# --- Duration ---
duration_str=""
if [[ -n "$duration_ms" ]]; then
  total_s=$(( duration_ms / 1000 ))
  mins=$(( total_s / 60 ))
  secs=$(( total_s % 60 ))
  if (( mins > 0 )); then
    duration_str="${YELLOW}${mins}m ${secs}s${RST}"
  else
    duration_str="${YELLOW}${secs}s${RST}"
  fi
fi

# --- Tokens / context ---
ctx_str=""
if [[ -n "$ctx_pct" ]]; then
  tok_count="$current_tok"
  if [[ -z "$tok_count" ]]; then
    tok_count="$total_tok"
  fi

  tok_label=""
  if [[ -n "$tok_count" ]]; then
    if (( tok_count >= 1000 )); then
      tok_label="$(printf '%.1fk' "$(echo "scale=1; $tok_count / 1000" | bc)")  "
    else
      tok_label="${tok_count}  "
    fi
  fi

  # Color context % by severity
  if (( ctx_pct >= 80 )); then
    pct_color=$(c 243 139 168)   # red
  elif (( ctx_pct >= 60 )); then
    pct_color=$PEACH              # peach/orange
  else
    pct_color=$TEAL               # teal
  fi
  ctx_str="${SUBTEXT}${tok_label}${pct_color}${ctx_pct}%${RST}"
fi

# --- Code changes ---
changes_str=""
if [[ -n "$lines_added" && -n "$lines_removed" ]] && (( lines_added > 0 || lines_removed > 0 )); then
  changes_str="${GREEN}+${lines_added}${RST}${DIM}/${RST}${PEACH}-${lines_removed}${RST}"
fi

# --- Assemble ---
parts=()
[[ -n "$repo_branch" ]]  && parts+=("$repo_branch")
[[ -n "$model_str" ]]    && parts+=("$model_str")
[[ -n "$premium_str" ]]  && parts+=("$premium_str")
[[ -n "$duration_str" ]] && parts+=("$duration_str")
[[ -n "$ctx_str" ]]      && parts+=("$ctx_str")
[[ -n "$changes_str" ]]  && parts+=("$changes_str")

if (( ${#parts[@]} == 0 )); then
  exit 0
fi

line=""
for i in "${!parts[@]}"; do
  if (( i > 0 )); then
    line+="$SEP"
  fi
  line+="${parts[$i]}"
done

printf '%b' "$line"
