{
  # キーボードの remap とシステムショートカットを管理する。
  # コメントは macOS の「システム設定」上の表記に合わせる。
  #
  # AppleSymbolicHotKeys は cfprefsd のキャッシュにより
  # darwin-rebuild switch 直後に反映されないことがある。
  # 確認は `defaults read com.apple.symbolichotkeys`、
  # 反映はログアウト/再起動で行う。
  system.keyboard = {
    enableKeyMapping = true; # キーマッピングを有効化 (以下の remap を有効にする)
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

    # アプリケーションのメニュー項目に対するショートカット上書き。
    # キーボード > キーボードショートカット > アプリのショートカット に相当。
    # 値は Cocoa 修飾子記法: @=Cmd, ^=Ctrl, ~=Opt, $=Shift
    NSUserKeyEquivalents = {
      # 例: 「ペーストしてスタイルを合わせる」を Cmd+V に
      # "Paste and Match Style" = "@v";
    };
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
    # Spotlight を表示: Cmd + Space (デフォルト)
    "64" = {
      enabled = true;
      value = {
        parameters = [
          32
          49
          1048576
        ];
        type = "standard";
      };
    };
    # Finder の検索ウインドウを表示: Cmd + Option + Space (デフォルト)
    "65" = {
      enabled = true;
      value = {
        parameters = [
          32
          49
          1572864
        ];
        type = "standard";
      };
    };
    # Mission Control: Ctrl + ↑
    "32" = {
      enabled = true;
      value = {
        parameters = [
          65535
          126
          8781824
        ];
        type = "standard";
      };
    };
    # アプリケーションウインドウ: Ctrl + ↓
    "33" = {
      enabled = true;
      value = {
        parameters = [
          65535
          125
          8781824
        ];
        type = "standard";
      };
    };
    # デスクトップを表示: 無効化 (キー競合回避)
    "36".enabled = false;
    # 前の入力ソースを選択: 無効 (Spotlight と競合するため)
    "60".enabled = false;
    # 次のソースを選択: 無効 (Spotlight と競合するため)
    "61".enabled = false;
  };
}
