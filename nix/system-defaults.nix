{ username, ... }:

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
      AppleReduceDesktopTinting = true; # 色合いを抑制 (システム設定の「壁紙の色合いを許可」をオフ)

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
      magnification = true; # 拡大: オン
      largesize = 128; # 拡大スライダの最大サイズ
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

    # デスクトップとDock > デスクトップとステージマネージャ
    WindowManager = {
      EnableStandardClickToShowDesktop = false; # クリックして壁紙を表示: オフ
      StandardHideDesktopIcons = false; # デスクトップ上の項目を表示 (Hide=false なので表示する)
      StandardHideWidgets = false; # ウィジェットを表示 (Hide=false)
      StageManagerHideWidgets = false; # ステージマネージャ時のウィジェット表示 (Hide=false)
      AppWindowGroupingBehavior = true; # ステージマネージャ: アプリケーションウインドウのグループ化
      AutoHide = true; # ステージマネージャ: 最近使ったアプリケーションを自動的に隠す
      HideDesktop = true; # ステージマネージャ: デスクトップアイコンを隠す
    };

    finder = {
      AppleShowAllExtensions = true; # すべてのファイル拡張子を表示
      ShowPathbar = true; # 表示 > パスバーを表示
      ShowStatusBar = true; # 表示 > ステータスバーを表示
      FXPreferredViewStyle = "Nlsv"; # 既定の表示形式: リスト表示
      FXDefaultSearchScope = "SCcf"; # 検索の対象: 現在のフォルダ
      FXEnableExtensionChangeWarning = false; # 拡張子変更時の確認ダイアログ: オフ
      _FXSortFoldersFirst = true; # フォルダを名前順で先に表示

      # Finder > 設定 > 一般 > 新規 Finder ウインドウで次を表示
      # PfAF=AirDrop, PfHm=ホーム, PfDe=デスクトップ, PfDo=書類, PfCm=コンピュータ, PfLo=その他
      NewWindowTarget = "PfAF"; # AirDrop
      # Finder > 設定 > 一般 > デスクトップに表示する項目
      ShowExternalHardDrivesOnDesktop = true; # 外部ディスク
      ShowHardDrivesOnDesktop = false; # 内蔵ディスク: オフ
      ShowRemovableMediaOnDesktop = true; # CD・DVD・iPod
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
      location = "/Users/${username}/Downloads"; # スクリーンショットの保存先
      show-thumbnail = true; # 撮影後にフローティングサムネールを表示
    };

    trackpad = {
      Clicking = true; # タップでクリック
      TrackpadRightClick = true; # 副ボタンのクリック (2本指でクリックまたはタップ)
      TrackpadThreeFingerDrag = false; # 3本指のドラッグ (アクセシビリティ > ポインタコントロール)
    };

    # トラックパッド > その他のジェスチャ / スクロールとズーム / ポイント＆クリック
    # nix-darwin の system.defaults.trackpad では扱えないため CustomUserPreferences で設定する。
    # 内蔵 (AppleMultitouchTrackpad) と Bluetooth (Bluetooth.trackpad) の両ドメインに同じ値を書く必要がある。
    # 値: スワイプ系 (Trackpad*FingerHorizSwipeGesture / VertSwipeGesture) は
    #     0=オフ, 1=オン (基本ジェスチャ), 2=フルジェスチャ (修飾なしで動作)。
    #     その他のキー (Pinch / Rotate / HorizScroll / DoubleTap / ForceSuppressed) は 0=オフ, 1=オン のみ。
    CustomUserPreferences =
      let
        trackpadGestures = {
          # その他のジェスチャ
          TrackpadFourFingerHorizSwipeGesture = 2; # 操作スペース間をスワイプ (4本指)
          TrackpadThreeFingerHorizSwipeGesture = 2; # 操作スペース間をスワイプ (3本指)
          TrackpadFourFingerVertSwipeGesture = 2; # Mission Control (4本指で上にスワイプ)
          TrackpadThreeFingerVertSwipeGesture = 2; # Mission Control (3本指で上にスワイプ)
          TrackpadFiveFingerPinchGesture = 0; # Launchpad (5本指でピンチ): オフ
          TrackpadFourFingerPinchGesture = 0; # デスクトップを表示 (4本指で広げる): オフ
          TrackpadTwoFingerFromRightEdgeSwipeGesture = 0; # 通知センター (右端から2本指でスワイプ): オフ
          # スクロールとズーム
          TrackpadTwoFingerDoubleTapGesture = 1; # スマートズーム (2本指でダブルタップ)
          TrackpadPinch = 1; # 拡大/縮小
          TrackpadRotate = 1; # 回転
          TrackpadHorizScroll = 1; # 水平スクロール
          # ポイント＆クリック
          ForceSuppressed = 1; # 強めのクリックと触覚フィードバック: オフ (抑止)
        };
      in
      {
        "com.apple.AppleMultitouchTrackpad" = trackpadGestures;
        "com.apple.driver.AppleBluetoothMultitouch.trackpad" = trackpadGestures;

        # アクセシビリティ (system.defaults.universalaccess の対応外キー)
        "com.apple.universalaccess" = {
          closeViewHotkeysEnabled = 0; # ズーム > キーボードショートカットを使用: オフ
          mouseDriver = 0; # ポインタコントロール > マウスキー: オフ
          slowKey = 0; # キーボード > スローキー: オフ
          stickyKey = 0; # キーボード > 複合キー (Sticky Keys): オフ
          grayscale = 0; # ディスプレイ > グレイスケールを使用: オフ
        };

        # ログインウインドウ (system.defaults.loginwindow の対応外キー)
        "com.apple.loginwindow" = {
          TALLogoutSavesState = 0; # 一般 > 終了時にウインドウを開きなおす: オフ
        };
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
