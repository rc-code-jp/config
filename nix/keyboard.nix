{
  # キーボードの remap とシステムショートカットを管理する。
  # コメントは macOS の「システム設定」上の表記に合わせる。
  #
  # AppleSymbolicHotKeys は cfprefsd のキャッシュにより
  # darwin-rebuild switch 直後に反映されないことがある。
  # 確認は `defaults read com.apple.symbolichotkeys`、
  # 反映はログアウト/再起動で行う。
  system.keyboard = {
    enableKeyMapping = true; # system.keyboard 配下の remap を有効化
    remapCapsLockToControl = true; # キーボード > キーボードショートカット > 修飾キー: Caps Lock を Control に変更
    swapLeftCommandAndLeftAlt = false; # 左 Command と左 Option の入れ替え: オフ
  };

  system.defaults.NSGlobalDomain = {
    # キーボード > キーボードショートカット > ファンクションキー
    # F1, F2 などのキーを標準のファンクションキーとして使用
    "com.apple.keyboard.fnState" = true;
    # キーボード > キーボードショートカット > キーボードナビゲーション
    # Tab キーですべてのコントロールに移動 (3 = フルキーボードアクセス)
    AppleKeyboardUIMode = 3;
  };

  # キーボード > 入力ソース / Fn キーの動作 (com.apple.HIToolbox ドメイン)
  system.defaults.CustomUserPreferences."com.apple.HIToolbox" = {
    # 🌐キー (Fn) を押したときの操作: 入力ソースを変更
    # 0=なし, 1=入力ソースを変更, 2=絵文字と記号を表示, 3=音声入力を開始
    AppleFnUsageType = 1;
    # Caps Lock を押し続けて英字入力モードに切替: オン
    # 0=オン (押し続けで切替), 1=オフ
    AppleCapsLockPressAndHoldToggleOff = 0;
  };

  # キーボード > キーボードショートカット に並ぶ項目を直接編集する。
  # AppleSymbolicHotKeys の主な ID:
  #   32  Mission Control
  #   33  アプリケーションウインドウ
  #   36  デスクトップを表示
  #   60  前の入力ソースを選択
  #   61  次のソースを選択
  #   64  Spotlight を表示
  #   65  Finder の検索ウインドウを表示
  #
  # parameters は [ ASCII値 仮想キーコード 修飾子フラグ ]。
  # 修飾子フラグ: shift=131072, control=262144, option=524288, command=1048576
  system.defaults.CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
    # Spotlight を表示: 無効 (キーボードから呼び出さない)
    "64".enabled = false;
    # Finder の検索ウインドウを表示: 無効 (キーボードから呼び出さない)
    "65".enabled = false;
    # Mission Control: 無効 (キーボードから呼び出さない)
    "32".enabled = false;
    # アプリケーションウインドウ: 無効 (キーボードから呼び出さない)
    "33".enabled = false;
    # デスクトップを表示: 無効化 (キー競合回避)
    "36".enabled = false;
    # 前の入力ソースを選択: 無効
    "60".enabled = false;
    # 次のソースを選択: 無効
    "61".enabled = false;
  };
}
