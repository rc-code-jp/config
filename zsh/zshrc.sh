# Config-Start

# ===== zsh completion start =====
fpath=("$HOME/.zsh/completions" $fpath)

# 履歴の設定
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS   # 重複を記録しない
setopt SHARE_HISTORY      # 履歴を他ターミナルと共有

# 履歴補完の設定（標準機能）
# 上下矢印キーで途中まで入力した内容に基づいた履歴検索
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

autoload -Uz compinit
compinit -C -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

# Options for completion and directory
setopt auto_cd
setopt pushd_ignore_dups
setopt list_packed
setopt list_types
setopt no_beep

# 補完候補を矢印キーで選択できるようにする
zstyle ':completion:*:default' menu select=2
# 補完時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# git status in prompt（vcs_info）
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
setopt PROMPT_SUBST

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a)'

_git_dirty_mark() {
  local status_info
  status_info=$(git status --porcelain 2>/dev/null) || return
  [[ -z "$status_info" ]] && return
  # Zshの内蔵パターンマッチングで高速判定
  if [[ "$status_info" =~ $'\n [MADRCU]' || "$status_info" =~ '^ [MADRCU]' ]]; then
    echo '*' # ワークツリーに修正あり
  elif [[ "$status_info" =~ $'\n[MADRCU]' || "$status_info" =~ '^[MADRCU]' ]]; then
    echo '+' # ステージングのみ修正あり
  fi
}

_prompt_precmd() {
  vcs_info
  print ''
}
add-zsh-hook precmd _prompt_precmd

PROMPT=$'%F{4}%~%f ${vcs_info_msg_0_}%F{1}$(_git_dirty_mark)%f\n%F{5}%#%f '
# ===== zsh completion end =====

# Key chain
(ssh-add --apple-load-keychain >/dev/null 2>&1 &)

# Alias
alias oz="open ~/.zshrc"
alias sz="source ~/.zshrc"
alias ..="cd .."
alias ll="ls -atrl" # リストを見やすく表示
alias O="open ." # 現在のディレクトリを開く
alias S="caffeinate -dimsu" # Sleepを防ぐ
alias Z="zed ." # Zedを起動

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
      1) echo "${fg[cyan]}Executing: ${fg[yellow]}git add -A${reset_color}"; git add -A ;;
      2) echo "${fg[cyan]}Executing: ${fg[yellow]}git commit -m <message>${reset_color}"; git_commit_message ;;
      3) echo "${fg[cyan]}Executing: ${fg[yellow]}git push origin HEAD${reset_color}"; git push origin HEAD ;;
      4) echo "${fg[cyan]}Executing: ${fg[yellow]}git pull${reset_color}"; git pull ;;
      5) echo "${fg[cyan]}Executing: ${fg[yellow]}git switch -c <branch_name>${reset_color}"; git_switch_branch create ;;
      6) echo "${fg[cyan]}Executing: ${fg[yellow]}git switch <branch_name>${reset_color}"; git_switch_branch switch ;;
      7) echo "${fg[cyan]}Executing: ${fg[yellow]}git status${reset_color}"; git status ;;
      ' ') continue ;;
      *) echo "${fg[red]}Error: Invalid choice '$c'.${reset_color}" >&2 ;;
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
    n=1
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
