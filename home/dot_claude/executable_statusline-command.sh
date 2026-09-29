#!/bin/bash
input=$(cat)

# 空欄やパス内の改行・タブを保持するため、NUL 区切りで読み取る。
# macOS 標準の Bash 3.2 でも使えるよう readarray は使わない。
fields=()
while IFS= read -r -d '' field; do
  fields+=("$field")
done < <(
  jq -j '[
    .cwd,
    .model.display_name // .model.id,
    .context_window.used_percentage,
    .rate_limits.five_hour.used_percentage,
    .rate_limits.five_hour.resets_at,
    .rate_limits.seven_day.used_percentage,
    .rate_limits.seven_day.resets_at,
    .worktree.name
  ] | .[] | (if . == null then "" else tostring end), "\u0000"' <<<"$input"
)
cwd=${fields[0]:-}
model=${fields[1]:-}
ctx_used_pct=${fields[2]:-}
FIVE_H=${fields[3]:-}
FIVE_H_RESET=${fields[4]:-}
WEEK=${fields[5]:-}
WEEK_RESET=${fields[6]:-}
wt_name=${fields[7]:-}

# --- CWD ---
user_home="$HOME"
short_cwd="${cwd#"$user_home"}"
if [ "$short_cwd" != "$cwd" ]; then
  short_cwd="~${short_cwd}"
fi

# --- Git ---
git_branch=""
git_dirty=""
if git -C "$cwd" rev-parse --is-inside-work-tree --no-optional-locks >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$git_branch" ]; then
    status_info=$(git -C "$cwd" status --porcelain 2>/dev/null)
    if [ -n "$status_info" ]; then
      case "$status_info" in
        *$'\n '[MADRCU]*|' '[MADRCU]*)  git_dirty="*" ;;
        *$'\n'[MADRCU]*|[MADRCU]*)      git_dirty="+" ;;
      esac
      if [ -z "$git_dirty" ]; then
        git_dirty="*"
      fi
    fi
  fi
fi

# --- Effort + Context ---
# effort は別ファイル参照のため統合対象外
effort=$(jq -r '.effortLevel // empty' ~/.claude/settings.json 2>/dev/null)

ctx_section=""
[ -n "$effort" ] && ctx_section=" effort:${effort}"
[ -n "$ctx_used_pct" ] && ctx_section="${ctx_section} ctx:$(printf '%.0f' "$ctx_used_pct")%"

# --- Rate limits ---
now=$(date +%s)

fmt_remaining() {
  local resets_at=$1
  local diff=$(( resets_at - now ))
  if [ "$diff" -le 0 ]; then
    echo "0m"
  elif [ "$diff" -ge 3600 ]; then
    echo "$(( diff / 3600 ))h$(( (diff % 3600) / 60 ))m"
  else
    echo "$(( diff / 60 ))m"
  fi
}

limits=""
if [ -n "$FIVE_H" ]; then
  limits="5h: $(printf '%.0f' "$FIVE_H")%"
  [ -n "$FIVE_H_RESET" ] && limits="$limits($(fmt_remaining "$FIVE_H_RESET"))"
fi
if [ -n "$WEEK" ]; then
  week_part="7d: $(printf '%.0f' "$WEEK")%"
  [ -n "$WEEK_RESET" ] && week_part="$week_part($(fmt_remaining "$WEEK_RESET"))"
  limits="${limits:+$limits  }$week_part"
fi

# --- Line 1: CWD + Git + Worktree ---
printf '\033[34m%s\033[0m' "$short_cwd"
if [ -n "$git_branch" ]; then
  printf ' (%s)' "$git_branch"
  if [ -n "$git_dirty" ]; then
    printf '\033[31m%s\033[0m' "$git_dirty"
  fi
fi
if [ -n "$wt_name" ]; then
  printf ' \033[36m[wt:%s]\033[0m' "$wt_name"
fi

# --- Line 2: [Model] Context | Limits ---
printf '\n'
if [ -n "$limits" ]; then
  printf '[%s]%s | %s' "$model" "$ctx_section" "$limits"
else
  printf '[%s]%s' "$model" "$ctx_section"
fi
