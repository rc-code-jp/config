# Nix 管理しない macOS 設定

このファイルは、macOS の「システム設定」には存在するが、このリポジトリの nix-darwin 設定では管理しない項目を記録する。

管理しない理由は主に次のどれか。

- 現在の nix-darwin に正式オプションがない
- 現在の nix-darwin の型や選択肢に合わない
- `CustomUserPreferences` で無理に書くと macOS / nix-darwin 更新時に壊れやすい
- macOS の保護や権限により `darwin-rebuild switch` 中に書き込み失敗しやすい

必要になった場合は手動で設定する。nix-darwin に正式オプションが追加されたら、改めて管理対象に戻す。

## デスクトップとDock

| システム設定の場所 | 項目 | defaults key | 管理しない理由 |
| --- | --- | --- | --- |
| デスクトップとDock > メニューバー | フルスクリーンでメニューバーを表示 | `NSGlobalDomain.AppleMenuBarVisibleInFullscreen` | 現在の nix-darwin では `system.defaults.NSGlobalDomain` の正式オプションではない |
| デスクトップとDock | タイトルバーをダブルクリックして「しまう」 | `NSGlobalDomain.AppleMiniaturizeOnDoubleClick` | 現在の nix-darwin では `system.defaults.NSGlobalDomain` の正式オプションではない |

## 外観 / 壁紙

| システム設定の場所 | 項目 | defaults key | 管理しない理由 |
| --- | --- | --- | --- |
| 外観 / 壁紙 | 壁紙の色合いを許可 | `NSGlobalDomain.AppleReduceDesktopTinting` | 現在の nix-darwin では `system.defaults.NSGlobalDomain` の正式オプションではない |

## マウス

| システム設定の場所 | 項目 | defaults key | 管理しない理由 |
| --- | --- | --- | --- |
| マウス | 軌跡の速さ | `NSGlobalDomain."com.apple.mouse.scaling"` | `system.defaults.".GlobalPreferences"."com.apple.mouse.scaling"` はあるが、既存設定の書き込み先と異なるため一旦管理しない |
| マウス | スクロールの速さ | `NSGlobalDomain."com.apple.scrollwheel.scaling"` | 現在の nix-darwin では正式オプションではない |

## サウンド / アクセシビリティ

| システム設定の場所 | 項目 | defaults key | 管理しない理由 |
| --- | --- | --- | --- |
| サウンド | ユーザインタフェースのサウンドエフェクトを再生 | `NSGlobalDomain."com.apple.sound.uiaudio.enabled"` | 現在の nix-darwin では正式オプションではない |
| アクセシビリティ > オーディオ | 警告音が鳴るときに画面を点滅させる | `NSGlobalDomain."com.apple.sound.beep.flash"` | 現在の nix-darwin では正式オプションではない |

## アクセシビリティ

| システム設定の場所 | 項目 | defaults key | 管理しない理由 |
| --- | --- | --- | --- |
| アクセシビリティ > ズーム | キーボードショートカットを使ってズーム | `com.apple.universalaccess.closeViewHotkeysEnabled` | `com.apple.universalaccess` への書き込みが `darwin-rebuild switch` 中に失敗したため管理しない |
| アクセシビリティ > ポインタコントロール | マウスキー | `com.apple.universalaccess.mouseDriver` | `com.apple.universalaccess` への書き込みが `darwin-rebuild switch` 中に失敗したため管理しない |
| アクセシビリティ > キーボード | スローキー | `com.apple.universalaccess.slowKey` | `com.apple.universalaccess` への書き込みが `darwin-rebuild switch` 中に失敗したため管理しない |
| アクセシビリティ > キーボード | 複合キー | `com.apple.universalaccess.stickyKey` | `com.apple.universalaccess` への書き込みが `darwin-rebuild switch` 中に失敗したため管理しない |
| アクセシビリティ > ディスプレイ | グレイスケールを使用 | `com.apple.universalaccess.grayscale` | `com.apple.universalaccess` への書き込みが `darwin-rebuild switch` 中に失敗したため管理しない |

## 一般

| システム設定の場所 | 項目 | defaults key | 管理しない理由 |
| --- | --- | --- | --- |
| 一般 | ログアウト時にウインドウを再度開く | `com.apple.loginwindow.TALLogoutSavesState` | `system.defaults.loginwindow` の正式オプションではないため管理しない |

## Finder

| システム設定の場所 | 項目 | defaults key | 管理しない理由 |
| --- | --- | --- | --- |
| Finder > 設定 > 一般 | 新規 Finder ウインドウで次を表示: AirDrop | `com.apple.finder.NewWindowTarget = "PfAF"` | nix-darwin の `system.defaults.finder.NewWindowTarget` は `AirDrop` を選択肢として受け付けない |
