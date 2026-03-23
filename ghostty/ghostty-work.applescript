-- Ghostty を起動し、開発用のペインレイアウトを自動構築するスクリプト
-- 使い方: osascript ghostty-work.applescript [フォルダパス]
--         引数を省略すると ~/src/ghostty ...
on run argv
	if (count of argv) > 0 then
		set projectDir to item 1 of argv
	else
		set projectDir to POSIX path of (path to home folder) & "src/ghostty"
	end if

	tell application "Ghostty"
		activate

		set win to front window

		set paneFiles to focused terminal of selected tab of win
		set paneAgent to split paneFiles direction right
		set paneShell to split paneFiles direction down
		set paneShell2 to split paneAgent direction down

		delay 0.3
		perform action "resize_split:left,480" on paneFiles
		perform action "resize_split:down,180" on paneShell
		perform action "resize_split:down,180" on paneShell2

		input text "C" to paneAgent
		send key "enter" to paneAgent

		input text "minishelf" to paneFiles
		send key "enter" to paneFiles

		focus paneAgent
	end tell
end run
