# MacBook Pro クリーン再インストール計画

作成日: 2026-07-31

## 目的

MacBook Proを初期化し、不要なアプリ、設定、キャッシュ、履歴を持ち込まずに、新しい環境として再構築する。

この計画では、Time Machineや移行アシスタントによる一括移行は使用しない。初期化前に必要性を1項目ずつ判断して退避し、初期化後も必要になったものだけを復元する。

## 基本方針

- Macは「新しいMac」としてセットアップする
- ホームディレクトリやアプリのデータを丸ごと復元しない
- Gitで復元できるリポジトリは、原則として再cloneする
- iCloudやブラウザ同期で復元できるデータは、同期結果を目視確認してから利用する
- 認証情報は可能な限り再ログインまたは再発行する
- 秘密鍵やGit管理外ファイルなど、再発行や再取得が難しいものだけを個別に退避する
- 設定はこのリポジトリのnix-darwinとchezmoiから復元する
- アプリ、CLI、言語ランタイム、エディタ拡張は、必要性を再判断してから導入する
- 退避したデータは、新環境の動作確認が完了するまで削除しない

## 完了条件

- 必要な作業データが新環境から利用できる
- GitHubへのclone、commit、pushができる
- このリポジトリからmacOS設定とdotfilesを適用できる
- 使用を継続するプロジェクトの開発環境が動作する
- 必要なアプリだけがインストールされている
- 旧環境のキャッシュ、ログ、使っていないアプリ設定を持ち込んでいない
- 退避対象と復元結果を項目ごとに確認済みにしている

## 復元の分類

各項目は、初期化前に次のいずれかへ分類する。

### 必ず復元する

再取得できないデータ、現在も使用しているデータ、秘密鍵など。

### 必要になったら復元する

履歴、過去の成果物、カスタム設定など。初期化後すぐには戻さず、必要性が確認できた時点で復元する。

### 復元しない

キャッシュ、ログ、ビルド成果物、再生成できる依存関係、現在使っていないアプリや設定。

## 退避先の準備

一括バックアップは作成しないが、選択したファイルの保存先は暗号化する。

推奨する構成例:

```text
Mac-clean-reinstall-2026-07-31/
├── credentials/
├── documents/
├── git-untracked/
├── custom-tools/
├── codex-selected/
├── app-settings-selected/
└── inventories/
```

秘密鍵や認証情報を保存するため、暗号化した外部ストレージまたは暗号化済みの信頼できる保存先を使用する。

各項目の退避後は、次のいずれかで内容を確認する。

- Finderからコピー先のファイルを実際に開く
- 元ファイルとコピー先のファイルサイズを比較する
- ディレクトリの場合はファイル数を比較する
- 重要なファイルはSHA-256チェックサムを比較する

## フェーズ1: 初期化前のGit整理

### 未コミット変更

- [ ] `~/work/prediction-ai`の次の変更内容を確認する
  - `packages/statistical-engine-nar/docs/NAR_DATA_CONTRACT.md`
  - `packages/statistical-engine-nar/src/nar_keiba_ai/prediction/daily.py`
  - `packages/statistical-engine-nar/tests/test_daily.py`
- [ ] 必要な変更ならコミットしてpushする
- [ ] 未完成でコミットしない場合は、対象ファイルまたはパッチを個別に退避する
- [ ] `~/work/pocogit`の未追跡`.DS_Store`は復元対象外とする

### 全リポジトリの確認

対象リポジトリ:

- `ai-ops`
- `config`
- `expense-manager-next`
- `expense_manager_flutter`
- `hougen-web`
- `investory`
- `multi-repo-nexus`
- `pocogit`
- `pocoshelf`
- `portfolio`
- `prediction-ai`
- `tobacco-map-web`

初期化直前に各リポジトリで確認する。

- [ ] `git fetch --all --prune`を実行する
- [ ] `git status`が意図した状態であることを確認する
- [ ] stashが残っていないことを確認する
- [ ] pushされていないコミットがないことを確認する
- [ ] リモートに存在しない必要なローカルブランチがないことを確認する
- [ ] リポジトリのURLとアクセス権を確認する

2026-07-31時点では、stashは全リポジトリで0件だった。取得済みのリモート参照と比較した範囲では、ローカルだけに存在するコミットも確認されなかった。ただし、初期化直前に最新のリモート情報で再確認する。

## フェーズ2: Git管理外データの選別

### 環境変数とプロジェクト固有データ

- [ ] `~/work/expense-manager-next/.env`を暗号化した保存先へ退避する
- [ ] コピー先の内容を開いて確認する
- [ ] 新環境で必要になる環境変数の用途を記録する

次のファイルは現在Git管理対象のため、リモートから復元できることを確認する。

- `~/work/expense_manager_flutter/fastlane/.env.dev`
- `~/work/expense_manager_flutter/fastlane/.env.local`
- `~/work/expense_manager_flutter/fastlane/.env.prd`
- `~/work/expense_manager_flutter/ios/Runner/GoogleService-Info.plist`

これらに実際の秘密情報が含まれる場合は、Gitでの管理を継続してよいかを別途見直す。

### Documents

2026-07-31時点の`~/Documents`は約760MB。

- [ ] Finderで直下の`Codex`を開き、必要な成果物を選ぶ
- [ ] Finderで直下の`test`を開き、必要性を判断する
- [ ] 必要なファイルだけを`documents/`へコピーする
- [ ] コピー先から代表的なファイルを開く
- [ ] `.DS_Store`は復元しない

### Desktop

macOSのプライバシー制限により、自動調査では内容を確認できなかった。

- [ ] Finderでデスクトップ上の全項目を確認する
- [ ] 必要なファイルだけを`documents/desktop/`へコピーする
- [ ] 一時ファイル、スクリーンショット、ダウンロード済みファイルは原則として復元しない

### Downloads、Music、Pictures、Movies

2026-07-31時点では、Downloads、Music、Pictures、Moviesの使用量は小さい。

- [ ] Finderで各フォルダを開く
- [ ] 再ダウンロードできないファイルだけを選ぶ
- [ ] 必要なファイルを個別に退避する

## フェーズ3: クラウド同期の目視確認

### iCloud

iCloud DriveのディレクトリとApple Accountの設定は現在のMacに存在する。ただし、デスクトップと書類フォルダの同期状態は手動確認が必要。

- [ ] iCloud.comへログインできることを確認する
- [ ] iCloud Drive上のフォルダと代表的なファイルを開く
- [ ] デスクトップと書類フォルダの同期設定を確認する
- [ ] メモ、連絡先、カレンダー、リマインダーを別デバイスから確認する
- [ ] 必要に応じて写真とメッセージの同期状態を確認する
- [ ] iCloudパスワードとキーチェーンが別デバイスで利用できることを確認する

iCloud上で確認できないデータだけを個別退避する。同期済みと判断したデータについても、重要なものは代表ファイルを実際に開いて確認する。

### Chrome

現在の設定上は同期セットアップ済み。

- [ ] Chromeの同期画面で同期中の項目を確認する
- [ ] 別端末または別セッションでブックマークを確認する
- [ ] 必要なパスワードが同期されていることを確認する
- [ ] 必要ならブックマークだけをHTMLでエクスポートする
- [ ] 確認できた場合は、約3.8GBあるChromeプロファイルをコピーしない

### Brave

現在の設定上は同期セットアップ済み。

- [ ] Brave Syncの同期チェーンを確認する
- [ ] ブックマーク、パスワード、拡張機能の同期状態を確認する
- [ ] 必要ならブックマークだけをエクスポートする
- [ ] 確認できた場合は、約295MBあるBraveプロファイルをコピーしない

## フェーズ4: 認証情報

### GitHub SSH

現在のSSH関連ファイル:

- `~/.ssh/config`
- `~/.ssh/id_ed25519_github`
- `~/.ssh/id_ed25519_github.pub`
- `~/.ssh/known_hosts`
- `~/.ssh/known_hosts.old`

推奨方針:

- 秘密鍵と設定は、初期化後にGitHubへアクセスできるまでの安全策として退避する
- `known_hosts`は原則として復元せず、新環境で再生成する
- 新しいSSH鍵へ切り替える場合も、cloneとpushの確認が終わるまで旧鍵を保管する

チェックリスト:

- [ ] `id_ed25519_github`を`credentials/ssh/`へコピーする
- [ ] `id_ed25519_github.pub`をコピーする
- [ ] `config`をコピーする
- [ ] 秘密鍵のコピー先が暗号化されていることを確認する
- [ ] GitHub上に現在の公開鍵が登録されていることを確認する
- [ ] Apple AccountまたはGitHubの2要素認証手段を確認する
- [ ] 必要なリカバリーコードを安全な場所に保管する

### GitHub CLI

現在の`gh`はログインしていない。

- [ ] 認証状態を復元しない
- [ ] 新環境で必要になった時点で`gh auth login`を実行する

### Gitのユーザー情報

Gitの名前とメールアドレスはこのリポジトリに含まれていない。

- [ ] 現在の設定値を安全な場所に記録する
- [ ] 新環境で`git config --global user.name`を設定する
- [ ] 新環境で`git config --global user.email`を設定する

## フェーズ5: カスタムスクリプトと個人ツール

### `~/bin`

現在のファイル:

- `sw`
- `sww`
- `ew`
- `go_panel_right`

- [ ] 各ファイルを開いて現在も必要か判断する
- [ ] 必要なスクリプトだけを`custom-tools/bin/`へコピーする
- [ ] 新環境で動作確認してから`~/bin`へ戻す
- [ ] 今後も使うスクリプトは、復元後にchezmoi管理へ移すことを検討する

### Antigravity CLI

現在は`~/.local/bin/agy`が存在するが、`antigravity`コマンドは見つからない。

- [ ] 今後も使用するか判断する
- [ ] 使用する場合は、バイナリをコピーせず公式手順で再インストールする
- [ ] 必要な履歴または成果物だけを`~/.gemini`と`~/.antigravity`から選別する
- [ ] `~/.zprofile`と`~/.zshrc`にあるAntigravity用PATHは、再インストール後に必要性を確認する

### `herdr`

- [ ] 今後も使用するか判断する
- [ ] 必要な場合は`~/.config/herdr/config.toml`だけを確認する
- [ ] `session.json`は原則として復元せず再ログインする
- [ ] ログファイルは復元しない

### `pocoshelf`

- [ ] 今後も使用するか判断する
- [ ] 必要な場合は`~/.config/pocoshelf/config.toml`を個別に退避する
- [ ] バイナリは新環境でNixから再インストールする

## フェーズ6: Codexデータの選別

現在の`~/.codex`は約7.1GB。ディレクトリ全体は復元しない。

### 必ず確認する候補

- `~/.codex/skills/hatch-pet`
- `~/.codex/pets/little-black-mage.codex-pet`
- `~/.codex/pets/totoro`
- `~/.codex/rules`
- `~/.codex/memories`
- `~/.codex/generated_images`
- `~/.codex/attachments`
- `~/.codex/archived_sessions`
- `~/.codex/sessions`

### 推奨する扱い

| 項目 | 方針 |
| --- | --- |
| `skills/hatch-pet` | 継続利用するなら個別退避 |
| カスタムペット | 継続利用するものだけ個別退避 |
| `generated_images` | 成果物として必要な画像だけ退避 |
| `attachments` | 元ファイルがほかにないものだけ退避 |
| `sessions` | 必要な過去タスクがある場合のみ保管用に退避 |
| `archived_sessions` | 必要性を目視確認してから退避 |
| `rules`、`memories` | 内容を確認して必要なものだけ退避 |
| `config.toml` | 参考用にコピーし、新環境では丸ごと上書きせず差分を確認 |
| `auth.json` | 復元せず再ログイン |
| `plugins` | 復元せず必要なプラグインだけ再インストール |
| `cache`、`.tmp` | 復元しない |
| `logs_2.sqlite` | 復元しない |
| `computer-use` | 復元しない |
| `Library/Application Support/Codex` | 原則として復元しない |

チェックリスト:

- [ ] CodexとChatGPTアプリを完全終了する
- [ ] カスタムスキルの内容を確認する
- [ ] カスタムペットを1つずつ確認する
- [ ] 必要な生成画像と添付ファイルを選ぶ
- [ ] 残したいタスク履歴があるか確認する
- [ ] 選んだものだけを`codex-selected/`へコピーする
- [ ] `auth.json`がコピー先へ紛れ込んでいないか確認する

このリポジトリの`home/dot_codex/config.toml`は基本設定を管理している。一方、現在の`~/.codex/config.toml`にはデスクトップ設定、プラグイン、MCP、プロジェクトの信頼設定など、アプリが追加した情報が含まれている。新環境ではリポジトリの設定を先に適用し、必要な設定だけを差分確認して追加する。

## フェーズ7: エディタ

### Visual Studio Code

設定ファイルはchezmoiから復元する。拡張機能は自動復元の対象外。

現在の拡張機能:

- `dart-code.dart-code`
- `dart-code.flutter`
- `ms-ceintl.vscode-language-pack-ja`
- `repreng.csv`

- [ ] VS Codeを使用し続けるか判断する
- [ ] DartまたはFlutter開発を継続する場合だけ対応拡張を入れる
- [ ] 日本語パックが必要か判断する
- [ ] CSV拡張が必要か判断する
- [ ] VS Codeの`Application Support`は復元しない

### Zed

設定ファイルはchezmoiから復元する。

現在の拡張機能:

- `catppuccin-icons`
- `git-firefly`
- `html`
- `solarized`

- [ ] Zedを使用し続けるか判断する
- [ ] 必要な拡張だけを再インストールする
- [ ] Zedの`Application Support`とローカル状態は復元しない

## フェーズ8: アプリの再選定

### リポジトリから導入されるアプリ

`nix/homebrew.nix`で現在宣言されているもの:

- Brave Browser
- Codex CLI
- Codexデスクトップアプリ
- Ghostty
- Google Chrome
- Visual Studio Code
- Zed
- OpenCode

初期化前に宣言自体を見直し、使用しないアプリは再構築前に設定から外す。

- [ ] BraveとChromeの両方が必要か判断する
- [ ] VS CodeとZedの両方が必要か判断する
- [ ] OpenCodeを継続利用するか判断する
- [ ] Codex CLIとデスクトップアプリの両方が必要か判断する

### 現在インストールされている管理外アプリ

| アプリ | 判断基準 |
| --- | --- |
| ChatGPT | Codexデスクトップアプリ適用後の構成を確認してから判断 |
| Logi Options+ | Logitech製品のボタン設定が必要な場合だけ導入 |
| RunCatNeo | 必要性を再判断 |
| Xcode | iOS、macOS、Flutter開発を続ける場合に導入 |
| GarageBand | 使用する場合だけApp Storeから導入 |
| iMovie | 使用する場合だけApp Storeから導入 |
| Pages | 使用する場合だけApp Storeから導入 |
| Numbers | 使用する場合だけApp Storeから導入 |
| Keynote | 使用する場合だけApp Storeから導入 |

アプリ本体や`Application Support`はコピーせず、必要なアプリだけを正規の配布元から再インストールする。

## フェーズ9: CLIと言語ランタイムの再選定

### nix-darwinから導入されるCLI

- chezmoi
- git
- jq
- mise
- fastlane
- CocoaPods
- switchaudio-osx

- [ ] fastlaneを使用するプロジェクトが残るか確認する
- [ ] CocoaPodsを使用するプロジェクトが残るか確認する
- [ ] 不要になったパッケージは初期化前に`nix/packages.nix`から外す

### 現在は宣言管理されていないCLI

- `gh`
- `herdr`
- `pocogit`
- `pocoshelf`
- `agy`

- [ ] それぞれ継続利用するか判断する
- [ ] 必要なものだけを新環境で再インストールする
- [ ] 継続利用する`pocogit`と`pocoshelf`は、将来的にこのリポジトリから宣言管理する

### mise

現在のグローバル設定:

- Node.js 24
- pnpm 10
- Flutter 3
- Rust stable
- Python 3.12.13
- uv latest

設定を適用しただけではランタイム本体は導入されない。

- [ ] 各ランタイムを使用するプロジェクトが残るか確認する
- [ ] 不要なランタイムは`home/dot_config/mise/config.toml`から外す
- [ ] 必要なものだけが残った状態で`mise install`を実行する
- [ ] プロジェクト固有バージョンは、対象プロジェクトを使う時点で導入する

## フェーズ10: 初期化後の再構築

### 1. macOSの初期設定

- [ ] 「新しいMac」としてセットアップする
- [ ] 移行アシスタントを使用しない
- [ ] Apple Accountへログインする
- [ ] FileVaultを有効にする
- [ ] macOSアップデートを適用する
- [ ] iCloud同期の完了を待つ

### 2. GitHubへアクセスできる状態を作る

- [ ] 旧SSH鍵を使用するか、新しい鍵を作るか決定する
- [ ] `~/.ssh`の権限を設定する
- [ ] GitHubへ公開鍵を登録する
- [ ] `ssh -T git@github.com`で接続を確認する

新しい鍵を作る場合、このリポジトリをHTTPSで取得して`bash scripts/github_setup.sh`を使用する方法も検討する。

### 3. Homebrewを導入する

- [ ] Homebrewを公式手順でインストールする
- [ ] `brew --version`を確認する

Homebrew本体はこのリポジトリの管理対象外である。

### 4. Nixを導入する

- [ ] macOS向けのマルチユーザー構成でNixをインストールする
- [ ] 新しいシェルで`nix --version`を確認する

現在のREADMEには、クリーン環境でのNix本体の導入手順と、`darwin-rebuild`が未導入の状態からの初回適用手順が不足している。初期化前にREADMEへ追加する。

### 5. 設定リポジトリを取得する

```bash
mkdir -p ~/work
git clone git@github.com:rc-code-jp/config.git ~/work/config
cd ~/work/config
```

- [ ] リポジトリをcloneできる
- [ ] `main`ブランチが最新である
- [ ] 初期化前に行った計画書と設定変更が含まれている

### 6. マシン固有設定を生成する

```bash
./scripts/bootstrap-local.sh
```

- [ ] ユーザー名を確認する
- [ ] ホスト名を確認する
- [ ] アーキテクチャが`aarch64-darwin`であることを確認する

### 7. nix-darwinを初回適用する

初回は`darwin-rebuild`がまだPATHにないため、`nix run`経由で実行する。

```bash
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#"$(scutil --get LocalHostName)"
```

- [ ] コマンドの内容と対象ホスト名を確認する
- [ ] 初回適用が完了する
- [ ] `darwin-rebuild`がPATHから実行できる
- [ ] Homebrew管理アプリが意図した一覧になっている

### 8. chezmoiを適用する

```bash
chezmoi --source "$PWD" diff
chezmoi --source "$PWD" apply
```

- [ ] `diff`をファイルごとに確認する
- [ ] 想定外の上書きがないことを確認する
- [ ] Codexを起動する前に基本設定を適用する
- [ ] `.zshrc`の管理ブロックが正しいことを確認する

### 9. Gitのユーザー情報を設定する

```bash
git config --global user.name "設定する名前"
git config --global user.email "設定するメールアドレス"
```

- [ ] `git config --global --list`で確認する

### 10. プロジェクトを必要なものから再cloneする

- [ ] 現在も使用するプロジェクトだけを選ぶ
- [ ] 1リポジトリずつcloneする
- [ ] 必要な`.env`だけを復元する
- [ ] `mise install`、`pnpm install`、`flutter pub get`などを必要な時点で実行する
- [ ] `node_modules`、Pods、DerivedData、ビルド成果物は旧環境からコピーしない

### 11. アプリを1つずつ確認する

各アプリで次を確認してから次へ進む。

- [ ] ログインできる
- [ ] 同期データが戻る
- [ ] 必要な設定だけを追加する
- [ ] 不要な拡張機能やプラグインを入れていない
- [ ] 旧環境のアプリデータをコピーする必要が本当にあるか再判断する

## 原則として復元しないもの

- Time Machineによる一括バックアップ
- 移行アシスタントによる一括移行
- ホームディレクトリ全体
- `~/Library`全体
- Homebrewのインストール済みディレクトリ
- `/nix/store`
- `node_modules`
- Dart、Flutter、Rust、Python、Node.jsのインストール済み本体
- CocoaPodsのPodsディレクトリ
- XcodeのDerivedDataとシミュレータ
- ブラウザキャッシュ
- Codexのログ、キャッシュ、`.tmp`
- VS CodeとZedのキャッシュ
- `known_hosts`
- `.DS_Store`
- アプリのログファイル
- 古い認証セッション

## 初期化を実行してよい条件

次のすべてを満たすまで初期化しない。

- [ ] `prediction-ai`の変更を保全した
- [ ] 全Gitリポジトリの最新状態を確認した
- [ ] `expense-manager-next/.env`を退避して開けることを確認した
- [ ] DocumentsとDesktopを目視確認した
- [ ] SSH秘密鍵を退避し、コピー先を確認した
- [ ] Apple AccountとGitHubの2要素認証手段を確認した
- [ ] iCloudの代表的なデータを別端末またはWebから確認した
- [ ] ChromeとBraveの同期結果を確認した
- [ ] `~/bin`の必要なスクリプトを選別した
- [ ] Codexのカスタムスキル、ペット、必要な成果物を選別した
- [ ] 継続利用するアプリとCLIを決めた
- [ ] Nixとnix-darwinの初回導入手順をREADMEへ追加した
- [ ] 退避した重要ファイルをコピー先から実際に開いた

## 初期化後の最終確認

- [ ] GitHubから必要なリポジトリをcloneできる
- [ ] テスト用の変更をcommitしてpushできる
- [ ] Ghosttyとシェル設定が動作する
- [ ] macOSのキーボード、Dock、Finder設定が反映されている
- [ ] 必要なブラウザデータが同期されている
- [ ] 必要なCodex設定とカスタムデータだけが戻っている
- [ ] 使用するエディタと必要な拡張だけが導入されている
- [ ] 使用するプロジェクトのビルドまたはテストが成功する
- [ ] 不要なアプリがインストールされていない
- [ ] 旧環境からの退避データを、最低2〜4週間は保持する

## 次の作業

1. `prediction-ai`の未コミット変更を確認する
2. 継続利用するアプリとCLIを決める
3. Git管理外データの退避先を準備する
4. この計画書に沿って、退避対象を1項目ずつ確認する
5. リポジトリの初回セットアップ手順と宣言管理対象を改善する
