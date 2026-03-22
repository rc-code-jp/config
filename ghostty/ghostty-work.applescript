-- Ghostty を起動し、開発用のペインレイアウトを自動構築するスクリプト
-- 使い方: osascript ghostty-work.applescript [フォルダパス]
--         引数を省略すると ~/src/ghostty ...

on run argv
    -- 引数があればそれを使い、なければデフォルトのパスにフォールバック
    if (count of argv) > 0 then
        set projectDir to item 1 of argv
    else
        set projectDir to POSIX path of (path to home folder) & "src/ghostty"
    end if

    tell application "Ghostty"
        activate

        -- ── ウィンドウ & 共通設定 ────────────────────────────────────
        set cfg to new surface configuration
        -- 全ペインの初期ディレクトリ
        set initial working directory of cfg to projectDir

        set win to new window with configuration cfg

        -- ── ペインレイアウト (グリッド構築) ──────────────────────────
        --
        --   ┌─────────────┬─────────────┐
        --   │  paneFiles  │  paneAgent  │  ← 右上: AIエージェント
        --   │  (ファイラ) ├─────────────┤
        --   ├─────────────┤  paneShell2 │  ← 右下: 汎用シェル2
        --   │  paneShell  │             │  ← 左下: 汎用シェル
        --   └─────────────┴─────────────┘
        --
        -- 1. まず左右に分割
        set paneFiles to terminal 1 of selected tab of win
        set paneAgent to split paneFiles direction right with configuration cfg
        -- 2. それぞれを上下に分割
        set paneShell to split paneFiles direction down with configuration cfg
        set paneShell2 to split paneAgent direction down with configuration cfg

        -- ── 各ペインへのコマンド入力 ─────────────────────────────────
        -- AIエージェント起動
        input text "C" to paneAgent
        send key "enter" to paneAgent
        -- ファイラ起動
        input text "minishelf" to paneFiles
        send key "enter" to paneFiles

        -- ── レイアウト調節 ──────────────────────────────────────────
        delay 0.3

        perform action "resize_split:left,480" on paneFiles
        perform action "resize_split:down,180" on paneShell
        perform action "resize_split:down,180" on paneShell2

        -- ── フォーカス ───────────────────────────────────────────────
        -- 作業開始時のフォーカスはAIエージェント
        focus paneAgent
    end tell
end run
