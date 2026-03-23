-- Ghostty を起動し、開発用のペインレイアウトを自動構築するスクリプト
-- 使い方: osascript ghostty-work.applescript [フォルダパス]
--         引数を省略すると ~/src/ghostty ...
on run argv
	-- 引数が渡されていればそれを使う
	-- 使わない場合はデフォルトのパスを入れておく
	if (count of argv) > 0 then
		set projectDir to item 1 of argv
	else
		set projectDir to POSIX path of (path to home folder) & "src/ghostty"
	end if

	tell application "Ghostty"
		-- Ghostty を前面に出す
		activate

		-- 現在のウィンドウを使う
		set win to front window

		-- 現在フォーカスされている terminal を起点にする
		set paneFiles to focused terminal of selected tab of win

		-- すでに分割済みなら、メッセージを表示して終了
		if (count of terminals of selected tab of win) > 1 then
			display dialog "このタブはすでに分割されています。"
			return
		end if

		-- 右側に 1 ペイン追加
		set paneAgent to split paneFiles direction right

		-- 左右それぞれを下方向に分割して 2x2 にする
		set paneShell to split paneFiles direction down
		set paneShell2 to split paneAgent direction down

		-- 分割直後はレイアウト確定待ち
		delay 0.3

		-- サイズ調整
		perform action "resize_split:left,480" on paneFiles
		perform action "resize_split:down,180" on paneShell
		perform action "resize_split:down,180" on paneShell2

		-- 右上ペインで C を実行
		input text "C" to paneAgent
		send key "enter" to paneAgent

		-- 左上ペインで minishelf を実行
		input text "minishelf" to paneFiles
		send key "enter" to paneFiles

		-- 最後に右上ペインへフォーカスを戻す
		focus paneAgent
	end tell
end run
