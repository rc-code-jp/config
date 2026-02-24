-- Tabのレイアウト関数を上書きして、プレビューを下に配置する
function Tab:layout()
  -- 画面全体（self._area）を上下に分割
  local chunks = ui.Layout()
      :direction(ui.Layout.VERTICAL)
      :constraints({
          ui.Constraint.Percentage(20),
          ui.Constraint.Percentage(80),
      })
      :split(self._area)

  -- 上部の領域をさらに左右に分割（親ディレクトリとカレントディレクトリ）
  local top_chunks = ui.Layout()
      :direction(ui.Layout.HORIZONTAL)
      :constraints({
          ui.Constraint.Ratio(1, 3), -- 親ディレクトリの割合
          ui.Constraint.Ratio(2, 3), -- カレントディレクトリの割合
      })
      :split(chunks[1])

  -- Yaziが期待する順番（1:親, 2:カレント, 3:プレビュー）で self._chunks に代入する
  self._chunks = {
      top_chunks[1],
      top_chunks[2],
      chunks[2],
  }
end