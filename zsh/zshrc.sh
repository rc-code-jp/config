# Config-Start

# Key chain
ssh-add --apple-load-keychain

# Alias
alias ll="ls -atrl"

# Alias Git
alias G="git"
alias GA="git add"
alias GC="git commit -m"
alias GP="git push origin"
alias Gp="git pull origin"
alias GS="git switch"
alias Gs="git status"
alias GB="git branch"
alias GR="git restore"

# Alias AI
alias C="opencode" # claude
alias CC="opencode --continue" # claude --continue

# Ghostty/一般的な端末のタブ/ウィンドウタイトルを「現在フォルダ名」にする
function _set_term_title_pwd() {
  # ${PWD:t} = パス末尾（フォルダ名）
  print -Pn "\e]2;${PWD:t}\a"
}
precmd_functions+=(_set_term_title_pwd)
chpwd_functions+=(_set_term_title_pwd)

# Config-End
