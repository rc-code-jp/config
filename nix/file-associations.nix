{ pkgs, username, lib, ... }:

let
  associations = [
    "com.apple.TextEdit  net.daringfireball.markdown  all" # .md
    "com.apple.TextEdit  public.json                   all" # .json
    "com.apple.TextEdit  public.toml                   all" # .toml
  ];

  dutiSettings = pkgs.writeText "duti-settings" (builtins.concatStringsSep "\n" associations);
in
{
  system.activationScripts.extraActivation.text = lib.mkAfter ''
    echo "ファイルの関連付けを設定しています..." >&2

    if ! sudo -u ${username} HOME=/Users/${username} ${pkgs.duti}/bin/duti ${dutiSettings}; then
      echo "エラー: duti によるファイル関連付けの設定に失敗しました" >&2
      exit 1
    fi

    echo "ファイルの関連付け設定が完了しました。" >&2
  '';
}
