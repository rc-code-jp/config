{
  # macOS の画面・UI 系の設定を nix-darwin で宣言的に管理する。
  # コメントは macOS の「システム設定」上の表記に合わせる。
  # 反映には darwin-rebuild switch 後にログアウト/再起動が必要な項目があります。
  system.defaults = {
    # NSGlobalDomain: アプリ全体に効くグローバル設定
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark"; # 外観モード: ダーク
      AppleShowAllExtensions = true; # すべてのファイル拡張子を表示
      AppleShowScrollBars = "Always"; # スクロールバーの表示: 常に表示
      ApplePressAndHoldEnabled = false; # キーの長押しでアクセント候補を出さずにリピート入力する
      InitialKeyRepeat = 15; # キーのリピート入力認識までの時間 (短いほど速い)
      KeyRepeat = 2; # キーのリピート速度 (短いほど速い)
      NSAutomaticCapitalizationEnabled = false; # 文頭を自動的に大文字にする: オフ
      NSAutomaticDashSubstitutionEnabled = false; # スマートダッシュ: オフ
      NSAutomaticPeriodSubstitutionEnabled = false; # ピリオドの自動入力 (スペース2回): オフ
      NSAutomaticQuoteSubstitutionEnabled = false; # スマート引用符: オフ
      NSAutomaticSpellingCorrectionEnabled = false; # スペルを自動的に修正: オフ
      NSNavPanelExpandedStateForSaveMode = true; # 保存ダイアログを最初から展開表示
      NSNavPanelExpandedStateForSaveMode2 = true; # 同上 (新形式)
      "com.apple.swipescrolldirection" = true; # スクロールの方向: ナチュラル
      "com.apple.trackpad.scaling" = 1.5; # 軌跡の速さ (トラックパッド > ポインタの軌跡の速さ)
    };

    dock = {
      autohide = true; # Dock を自動的に表示/非表示
      autohide-delay = 0.0; # 自動表示までの待ち時間 (秒)
      autohide-time-modifier = 0.2; # 表示アニメーションの長さ (秒)
      orientation = "bottom"; # 画面上の位置: 下
      tilesize = 48; # サイズ (アイコンの大きさ)
      mineffect = "scale"; # ウインドウをしまうときのエフェクト: スケールエフェクト
      minimize-to-application = true; # ウインドウをアプリケーションアイコンにしまう
      mru-spaces = false; # 最新のものに基づいて操作スペースを自動的に並べ替える: オフ
      show-recents = false; # 最近使用したアプリケーションを Dock に表示: オフ
      expose-group-apps = true; # Mission Control でアプリケーションごとにグループ化
      # ホットコーナー (デスクトップとDock > ホットコーナー) — 1 = なし
      wvous-tl-corner = 1; # 左上: なし
      wvous-tr-corner = 1; # 右上: なし
      wvous-bl-corner = 1; # 左下: なし
      wvous-br-corner = 1; # 右下: なし
    };

    finder = {
      AppleShowAllFiles = true; # 隠しファイルを表示
      AppleShowAllExtensions = true; # すべてのファイル拡張子を表示
      ShowPathbar = true; # 表示 > パスバーを表示
      ShowStatusBar = true; # 表示 > ステータスバーを表示
      FXPreferredViewStyle = "Nlsv"; # 既定の表示形式: リスト表示
      FXDefaultSearchScope = "SCcf"; # 検索の対象: 現在のフォルダ
      FXEnableExtensionChangeWarning = false; # 拡張子変更時の確認ダイアログ: オフ
      _FXShowPosixPathInTitle = true; # タイトルバーに完全パスを表示
      _FXSortFoldersFirst = true; # フォルダを名前順で先に表示
      QuitMenuItem = true; # Finder を終了メニューを有効化
    };

    menuExtraClock = {
      IsAnalog = false; # 時計の表示形式: デジタル
      ShowDate = 1; # 日付を表示: 常に表示 (0=自動 1=常に 2=表示しない)
      ShowDayOfWeek = true; # 曜日を表示
      ShowSeconds = false; # 秒を表示: オフ
      Show24Hour = true; # 24時間表示を使用
      ShowAMPM = false; # AM/PM を表示: オフ
    };

    screencapture = {
      location = "~/Pictures/Screenshots"; # スクリーンショットの保存先
      type = "png"; # スクリーンショットのフォーマット
      disable-shadow = true; # ウインドウ撮影時の影: なし
      show-thumbnail = true; # 撮影後にフローティングサムネールを表示
    };

    trackpad = {
      Clicking = true; # タップでクリック
      TrackpadRightClick = true; # 副ボタンのクリック (2本指でクリックまたはタップ)
      TrackpadThreeFingerDrag = true; # 3本指のドラッグ (アクセシビリティ > ポインタコントロール)
      ActuationStrength = 0; # 感圧クリック: 無効 (0=サイレントクリック)
    };

    # Mission Control > ディスプレイごとに個別の操作スペース: オフ
    spaces.spans-displays = false;

    LaunchServices = {
      LSQuarantine = false; # インターネットからダウンロードしたアプリを開く前の警告: オフ
    };

    loginwindow = {
      GuestEnabled = false; # ゲストユーザを許可: オフ
      SHOWFULLNAME = false; # ログインウインドウの表示: ユーザのリスト
    };
  };
}
