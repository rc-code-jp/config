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

		-- 現在のウィンドウ / タブ / フォーカス中 terminal を取得
		set win to front window
		set currentTab to selected tab of win
		set paneFiles to focused terminal of currentTab

		-- すでに分割されている場合は確認する
		if (count of terminals of currentTab) > 1 then
			set dialogResult to display dialog "このタブはすでに分割されています。現在の分割をすべて閉じて作り直しますか？" buttons {"いいえ", "はい"} default button "いいえ"

			-- 「はい」以外なら何もしない
			if button returned of dialogResult is not "はい" then
				input text "echo 'すでに分割されているため処理をスキップしました'\n" to paneFiles
				return
			end if

			-- フォーカス中 terminal を 1 つ残して、それ以外を閉じる
			set allTerms to terminals of currentTab
			repeat with t in allTerms
				if (id of t) is not (id of paneFiles) then
					close t
				end if
			end repeat

			-- close 後の状態反映待ち
			delay 0.2

			-- 念のため、残った terminal を取り直す
			set paneFiles to focused terminal of selected tab of win
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
		input text " C" to paneAgent
		send key "enter" to paneAgent

		-- 左上ペインで minishelf を実行
		input text " minishelf" to paneFiles
		send key "enter" to paneFiles

		-- 最後に右上ペインへフォーカスを戻す
		focus paneAgent
	end tell
end run
