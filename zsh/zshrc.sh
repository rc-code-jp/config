# Config-Start
export CLICOLOR=1

# ===== zsh completion start =====
fpath=("$HOME/.zsh/completions" $fpath)

# 履歴の設定
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_SPACE  # 先頭スペース付きコマンドを履歴に残さない
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
setopt pushd_ignore_dups  # ディレクトリスタックに同じディレクトリを重複して追加しない
setopt list_packed        # 補完候補を隙間なく詰めて表示する
setopt list_types         # 補完候補にファイル種別の識別マーク(/, *など)を付けて表示する
setopt no_beep            # コマンド入力エラー時などにビープ音を鳴らさない

# 補完候補を矢印キーで選択できるようにする
zstyle ':completion:*:default' menu select=2
# 補完時に大文字小文字を区別しない + 部分一致を許可
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

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
  if [[ "$status_info" =~ $'\n [MADRCU]' || "$status_info" =~ '^ [MADRCU]' \
     || "$status_info" =~ $'\n[?][?]'    || "$status_info" =~ '^[?][?]' ]]; then
    echo '*' # ワークツリーに修正あり or 未追跡ファイルあり
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

# Alias General
alias ..="cd .."
alias l="ls -a"
alias ll="ls -atrl" # リストを見やすく表示
alias vi="vim"
alias zzz="echo 'no sleep ...' && caffeinate -dimsu" # Sleepを防ぐ

# Alias Tools
alias m="minishelf"
alias mm="minishelf --tree-mode changed"
alias z="zed ."

# AI Alias
if command -v codex &>/dev/null; then
  alias ai="codex"
  alias aii="codex resume"
elif command -v claude &>/dev/null; then
  alias ai="claude"
  alias aii="claude --resume"
fi

# Alias Git
alias ga="git add -A"
alias gc="git_commit_message"
alias gp="git push origin HEAD"
alias ggg="ga && gc && gp"
alias gl="git pull"
alias gw="git_switch"
alias gs="git status"

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

# Git switch branch (interactive)
function git_switch() {
  local mode="${1:-auto}" branch_name key k1 k2
  local typed="" i
  local selected=1
  local rendered_lines=0
  local line_count=0
  local -a branches

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: Not inside a git repository." >&2
    return 1
  fi

  if [[ "$mode" == "create" ]]; then
    echo -n "New branch name> "
    read -r branch_name
    [[ -z "$branch_name" ]] && { echo "Error: Branch name cannot be empty." >&2; return 1; }
    git switch -c "$branch_name"
    return $?
  fi

  branches=("${(@f)$(git for-each-ref --format='%(refname:short)' --sort=-committerdate refs/heads)}")
  (( ${#branches} == 0 )) && { echo "Error: No local branches found." >&2; return 1; }

  while true; do
    if (( rendered_lines > 0 )); then
      printf "\033[%dA\r\033[J" "$rendered_lines"
    fi

    echo "git switch: ↑/↓ select"
    line_count=1
    if [[ "$mode" == "auto" ]]; then
      echo "New branch> ${typed:-"(type to create)"}"
      (( line_count++ ))
    fi
    echo "Branches:"
    (( line_count++ ))
    for (( i = 1; i <= ${#branches}; i++ )); do
      (( i == selected )) && echo "> ${branches[i]}" || echo "  ${branches[i]}"
    done
    rendered_lines=$((line_count + ${#branches}))

    read -rs -k 1 key || return 1
    case "$key" in
      $'\003') echo ""; echo "Cancelled."; return 130 ;;
      $'\n'|$'\r')
        echo ""
        if [[ "$mode" == "auto" && -n "$typed" ]]; then
          git show-ref --verify --quiet "refs/heads/$typed" && git switch "$typed" || git switch -c "$typed"
        else
          git switch "${branches[selected]}"
        fi
        return $?
        ;;
      $'\177'|$'\010')
        [[ "$mode" == "auto" && -n "$typed" ]] && typed="${typed[1,-2]}"
        ;;
      $'\e')
        read -rs -k 1 -t 0.01 k1 || continue
        [[ "$k1" != "[" ]] && continue
        read -rs -k 1 -t 0.01 k2 || continue
        case "$k2" in
          A) (( selected = selected > 1 ? selected - 1 : ${#branches} )) ;;
          B) (( selected = selected < ${#branches} ? selected + 1 : 1 )) ;;
        esac
        ;;
      *)
        [[ "$mode" == "auto" && "$key" == [[:print:]] ]] && typed+="$key"
        ;;
    esac
  done
}

# Config-End
