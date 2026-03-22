-- Ghostty を起動し、開発用のペインレイアウトを自動構築するスクリプト
-- 使い方: osascript ghostty-work-start.applescript [フォルダパス]
--         引数を省略すると ~/src/ghostty を使用

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

        -- ── ペインレイアウト ─────────────────────────────────────────
        --
        --   ┌─────────────┬─────────────┐
        --   │             │  paneEditor │  ← 右上: エディタ
        --   │  paneFiles  ├─────────────┤
        --   │ (ファイラ)  │  paneShell  │  ← 右下: 汎用シェル
        --   └─────────────┴─────────────┘
        --
        -- 左ペイン (起点)
        set paneFiles  to terminal 1 of selected tab of win
        -- 右上
        set paneEditor to split paneFiles  direction right with configuration cfg
        -- 右下
        set paneShell  to split paneEditor direction down  with configuration cfg

        -- ── 各ペインへのコマンド入力 ─────────────────────────────────
        -- エディタ起動
        input text "C"          to paneEditor
        send key "enter"        to paneEditor
        -- ファイラ起動
        input text "minishelf"  to paneFiles
        send key "enter"        to paneFiles

        -- ── フォーカス ───────────────────────────────────────────────
        -- 作業開始時のフォーカスはエディタ
        focus paneEditor
    end tell
end run
