{
  # macOS の画面・UI 系の設定を nix-darwin で宣言的に管理する。
  # コメントは macOS の「システム設定」上の表記に合わせる。
  # 反映には darwin-rebuild switch 後にログアウト/再起動が必要な項目があります。
  system.defaults = {
    # NSGlobalDomain: アプリ全体に効くグローバル設定
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark"; # 外観モード: ダーク
      AppleShowAllExtensions = true; # すべてのファイル拡張子を表示
      AppleShowScrollBars = "Automatic"; # スクロールバーの表示: 自動
      InitialKeyRepeat = 25; # キーのリピート入力認識までの時間 (短いほど速い)
      KeyRepeat = 12; # キーのリピート速度 (短いほど速い)
      NSAutomaticCapitalizationEnabled = false; # 文頭を自動的に大文字にする: オフ
      NSAutomaticDashSubstitutionEnabled = false; # スマートダッシュ: オフ
      NSAutomaticPeriodSubstitutionEnabled = false; # ピリオドの自動入力 (スペース2回): オフ
      NSAutomaticQuoteSubstitutionEnabled = false; # スマート引用符: オフ
      NSAutomaticSpellingCorrectionEnabled = false; # スペルを自動的に修正: オフ
      "com.apple.swipescrolldirection" = true; # スクロールの方向: ナチュラル
      "com.apple.trackpad.scaling" = 3.0; # 軌跡の速さ (トラックパッド > ポインタの軌跡の速さ)

      # メニューバー (コントロールセンター > メニューバー)
      AppleMenuBarVisibleInFullscreen = false; # フルスクリーンでメニューバーを表示: オフ
      "_HIHideMenuBar" = false; # メニューバーを自動的に表示/非表示: オフ

      # ウインドウ操作 (デスクトップとDock)
      AppleMiniaturizeOnDoubleClick = false; # タイトルバーをダブルクリックして「しまう」動作: 無効

      # 外観
      AppleReduceDesktopTinting = true; # 壁紙の色合いを許可: オフ (色合いを抑制)

      # キーボード
      NSAutomaticInlinePredictionEnabled = false; # 入力予測を表示: オフ

      # マウス
      AppleEnableMouseSwipeNavigateWithScrolls = true; # スクロールジェスチャでページ間を移動: オン
      "com.apple.mouse.scaling" = 3.0; # マウス > 軌跡の速さ
      "com.apple.scrollwheel.scaling" = 0.75; # マウス > スクロールの速さ

      # トラックパッド
      "com.apple.trackpad.forceClick" = false; # 強めのクリックと触覚フィードバック: オフ

      # サウンド / アクセシビリティ (オーディオ)
      "com.apple.sound.beep.feedback" = 1; # 音量変更時にフィードバック: オン
      "com.apple.sound.beep.flash" = 0; # ビープ音と同時に画面をフラッシュ (アクセシビリティ): オフ
      "com.apple.sound.uiaudio.enabled" = 1; # ユーザインタフェースのサウンドエフェクトを再生: オン
      "com.apple.sound.beep.volume" = 1.0; # 警告音の音量
    };

    dock = {
      autohide = true; # Dock を自動的に表示/非表示
      orientation = "bottom"; # 画面上の位置: 下
      tilesize = 76; # サイズ (アイコンの大きさ)
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
      AppleShowAllExtensions = true; # すべてのファイル拡張子を表示
      ShowPathbar = true; # 表示 > パスバーを表示
      ShowStatusBar = true; # 表示 > ステータスバーを表示
      FXPreferredViewStyle = "Nlsv"; # 既定の表示形式: リスト表示
      FXDefaultSearchScope = "SCcf"; # 検索の対象: 現在のフォルダ
      FXEnableExtensionChangeWarning = false; # 拡張子変更時の確認ダイアログ: オフ
      _FXSortFoldersFirst = true; # フォルダを名前順で先に表示
    };

    menuExtraClock = {
      IsAnalog = false; # 時計の表示形式: デジタル
      ShowDate = 0; # 日付を表示: 自動 (0=自動 1=常に 2=表示しない)
      ShowDayOfWeek = true; # 曜日を表示
      ShowSeconds = false; # 秒を表示: オフ
      Show24Hour = true; # 24時間表示を使用
      ShowAMPM = false; # AM/PM を表示: オフ
    };

    screencapture = {
      location = "~/Downloads"; # スクリーンショットの保存先
      show-thumbnail = true; # 撮影後にフローティングサムネールを表示
    };

    trackpad = {
      Clicking = true; # タップでクリック
      TrackpadRightClick = true; # 副ボタンのクリック (2本指でクリックまたはタップ)
      TrackpadThreeFingerDrag = false; # 3本指のドラッグ (アクセシビリティ > ポインタコントロール)
    };

    # Mission Control > ディスプレイごとに個別の操作スペース: オフ
    spaces.spans-displays = false;

    loginwindow = {
      GuestEnabled = false; # ゲストユーザを許可: オフ
      SHOWFULLNAME = false; # ログインウインドウの表示: ユーザのリスト
    };
  };

  # サウンド > 起動時にサウンドを再生: オフ
  # NVRAM 領域のため system.defaults では制御できず、activationScripts で nvram を直接設定する。
  system.activationScripts.startupChime.text = ''
    /usr/sbin/nvram StartupMute=%01
  '';
}
