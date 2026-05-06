{
  # キーボード remap とシステムショートカット (symbolic hotkeys) を管理する。
  #
  # symbolic hotkeys は cfprefsd のキャッシュにより darwin-rebuild switch
  # 直後には反映されないことがある。確実に反映させたい場合は
  #   defaults read com.apple.symbolichotkeys
  # で値を確認した上でログアウト/再起動する。
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
    swapLeftCommandAndLeftAlt = false;
  };

  system.defaults.NSGlobalDomain = {
    # Fn キーをファンクションキーとして扱う
    "com.apple.keyboard.fnState" = true;
    # Tab で全 UI 要素にフォーカス移動
    AppleKeyboardUIMode = 3;

    # アプリメニュー項目のショートカット上書き例。
    # キー: メニュー項目名 (英語)、値: Cocoa 修飾子記法
    #   @=Cmd, ^=Ctrl, ~=Opt, $=Shift
    NSUserKeyEquivalents = {
      # 例: 全アプリで「ペーストしてスタイルを合わせる」を Cmd+V に
      # "Paste and Match Style" = "@v";
    };
  };

  # システムレベルのショートカット (Spotlight / Mission Control / 入力ソース等)。
  # AppleSymbolicHotKeys の各 ID は以下のとおり (主要なもの)。
  #   32  Mission Control
  #   33  Application windows
  #   36  Show Desktop
  #   60  Select previous input source
  #   61  Select next input source
  #   64  Spotlight: Show Spotlight search
  #   65  Spotlight: Show Finder search window
  #   118 Switch to Desktop 1
  #   119 Switch to Desktop 2
  #
  # parameters の配列は [ ASCII値 仮想キーコード 修飾子フラグ ] の3要素。
  # 修飾子フラグ:
  #   shift=131072, control=262144, option=524288, command=1048576
  system.defaults.CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
    # Spotlight を Cmd+Space に固定 (デフォルト)
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
    # Spotlight Finder 検索を Cmd+Opt+Space に固定 (デフォルト)
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
    # Mission Control: Ctrl+Up
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
    # Application windows: Ctrl+Down
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
    # Show Desktop を無効化 (キー競合回避)
    "36".enabled = false;
    # 入力ソース切替を無効化 (Spotlight 競合回避)
    "60".enabled = false;
    "61".enabled = false;
  };
}
