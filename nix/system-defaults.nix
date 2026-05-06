{
  # macOS の画面・UI 系の設定を nix-darwin で宣言的に管理する。
  # 反映には darwin-rebuild switch 後にログアウト/再起動が必要な項目があります。
  system.defaults = {
    # NSGlobalDomain: グローバルな UI / 入力挙動
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      "com.apple.swipescrolldirection" = true;
      "com.apple.trackpad.scaling" = 1.5;
    };

    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      orientation = "bottom";
      tilesize = 48;
      mineffect = "scale";
      minimize-to-application = true;
      mru-spaces = false;
      show-recents = false;
      expose-group-apps = true;
      # ホットコーナー無効化 (1 = 無効)
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
    };

    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferredViewStyle = "Nlsv"; # List view
      FXDefaultSearchScope = "SCcf"; # Search current folder
      FXEnableExtensionChangeWarning = false;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
      QuitMenuItem = true;
    };

    menuExtraClock = {
      IsAnalog = false;
      ShowDate = 1; # 0=auto, 1=always, 2=never
      ShowDayOfWeek = true;
      ShowSeconds = false;
      Show24Hour = true;
      ShowAMPM = false;
    };

    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
      disable-shadow = true;
      show-thumbnail = true;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
      ActuationStrength = 0;
    };

    # 該当する spaces 系 (各ディスプレイに個別 Space を使うか)
    spaces.spans-displays = false;

    LaunchServices = {
      LSQuarantine = false;
    };

    loginwindow = {
      GuestEnabled = false;
      SHOWFULLNAME = false;
    };
  };
}
