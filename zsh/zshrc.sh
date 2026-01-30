# Config-Start

# Key chain
ssh-add --apple-load-keychain

# Alias
alias ll="ls -atrl"

# Alias Git
alias GA="git add -A"
alias GP="git push origin HEAD"
alias Gp="git pull"
alias GC="git_commit_message"
alias GS="git_switch_create"

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

# Git switch and create branch
function git_switch_create() {
  local branch_name
  echo -n "Branch name> "
  read -r branch_name
  if [[ -z "$branch_name" ]]; then
    echo "Error: Branch name cannot be empty." >&2
    return 1
  fi
  git switch -c "$branch_name"
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
