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
  # Open Codeをclaude resumeのように起動する
  local sid
  sid="$(
    opencode session list \
    | sed 1d \                                    # ヘッダー行を削除
    | grep -vE '^-+$|^─+$' \                      # 区切り線を除外
    | awk '{$1=""; print substr($0,2)}' \         # Session ID列を削除（Title, Updated列のみ表示）
    | nl -w2 -s': ' \                             # 行番号を付与（2桁幅、コロン区切り）
    | sed -n '1,20p'                              # 最初の20行のみ表示
  )"
  echo "$sid"
  echo -n "Session Number> "
  read -r n
  # 選択された番号のSession IDを取得してセッションを開く
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
