# Config-Start

# ===== zsh completion start =====
fpath=("$HOME/.zsh/completions" $fpath)

autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' menu select search

# git status in prompt（vcs_info）
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
setopt PROMPT_SUBST

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a)'

_git_dirty_mark() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
  git diff --quiet --ignore-submodules -- 2>/dev/null || { echo '*'; return }
  git diff --cached --quiet --ignore-submodules -- 2>/dev/null || { echo '+'; return }
}

_prompt_precmd() {
  vcs_info
  print ''
}
add-zsh-hook precmd _prompt_precmd

PROMPT=$'%F{4}%~%f ${vcs_info_msg_0_}%F{1}$(_git_dirty_mark)%f\n%F{5}%#%f '
# ===== zsh completion end =====


# Key chain
ssh-add --apple-load-keychain

# Alias
alias ll="ls -atrl"

# Git
alias G="git_command_pallet"

# Git command palette
function git_command_pallet() {
  echo "Git Commands:"
  echo " 1: git add -A"
  echo " 2: git commit (interactive)"
  echo " 3: git push origin HEAD"
  echo " 4: git pull"
  echo " 5: git switch -c (create new branch)"
  echo " 6: git switch (switch to existing branch)"
  echo " 7: git status"
  echo -n "Select> "
  read -r choice

  if [[ -z "$choice" ]]; then
    echo "Cancelled."
    return 0
  fi

  local c
  for c in ${(s::)choice}; do
    case "$c" in
      1) echo "Executing: git add -A"; git add -A ;;
      2) echo "Executing: git commit -m <message>"; git_commit_message ;;
      3) echo "Executing: git push origin HEAD"; git push origin HEAD ;;
      4) echo "Executing: git pull"; git pull ;;
      5) echo "Executing: git switch -c <branch_name>"; git_switch_branch create ;;
      6) echo "Executing: git switch <branch_name>"; git_switch_branch switch ;;
      7) echo "Executing: git status"; git status ;;
      ' ') continue ;;
      *) echo "Error: Invalid choice '$c'." >&2 ;;
    esac
  done
}

# Git commit with message
function git_commit_message() {
  local message
  echo -n "Commit message> "
  read -r message
  if [[ -z "$message" ]]; then
    echo "Error: Commit message cannot be empty." >&2
    return 1
  fi
  git commit -m "$message"
}

# Git switch branch
function git_switch_branch() {
  local create_mode="$1"
  local branch_name
  
  echo -n "Branch name> "
  read -r branch_name
  if [[ -z "$branch_name" ]]; then
    echo "Error: Branch name cannot be empty." >&2
    return 1
  fi
  
  if [[ "$create_mode" == "create" ]]; then
    git switch -c "$branch_name"
  else
    git switch "$branch_name"
  fi
}

# AI-claudecode-Start
alias C="claude"
alias CC="claude --resume"
# AI-claudecode-End

# AI-codex-Start
alias C="codex"
alias CC="codex resume"
# AI-codex-End

# AI-opencode-Start
alias C="opencode"
alias CC="opencode_resume"
function opencode_resume() {
  local sid
  sid="$(
    opencode session list | sed 1d | grep -vE '^-+$|^─+$' \
    | awk '{$1=""; print substr($0,2)}' \
    | nl -w2 -s': ' \
    | sed -n '1,40p'
  )"
  echo "$sid"
  echo -n "Session Number> "
  read -r n
  if [[ -z "$n" ]]; then
    echo "Error: Session Number is required." >&2
    return 1
  fi
  if ! [[ "$n" =~ ^[0-9]+$ ]]; then
    echo "Error: Session Number must be a number." >&2
    return 1
  fi
  opencode --session "$(opencode session list | sed 1d | grep -vE '^-+$|^─+$' | sed -n "${n}p" | awk '{print $1}')"
}
# AI-opencode-End

# Ghostty/一般的な端末のタブ/ウィンドウタイトルを「現在フォルダ名」にする
function _set_term_title_pwd() {
  # ${PWD:t} = パス末尾（フォルダ名）
  print -Pn "\e]2;${PWD:t}\a"
}
precmd_functions+=(_set_term_title_pwd)
chpwd_functions+=(_set_term_title_pwd)

# Config-End
