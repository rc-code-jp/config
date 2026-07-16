{ pkgs, ... }:

{
  # AirPods 接続時に入力デバイスだけ内蔵マイクへ戻す。
  # 出力(音楽再生など)は AirPods のまま維持される。
  # 常駐プロセスは持たず、launchd が 30 秒ごとに一度だけ実行する。
  launchd.user.agents.force-builtin-mic = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        ''
          current=$(${pkgs.switchaudio-osx}/bin/SwitchAudioSource -c -t input)
          case "$current" in
            *AirPods*)
              ${pkgs.switchaudio-osx}/bin/SwitchAudioSource -t input -s "MacBook Proのマイク"
              ;;
          esac
        ''
      ];
      StartInterval = 30;
      RunAtLoad = true;
      ProcessType = "Background";
    };
  };
}
