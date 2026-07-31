{
  enableSwitchAudio,
  lib,
  pkgs,
  ...
}:

{
  # 入力デバイスを常に内蔵マイクへ固定する。
  # 出力(音楽再生など)は接続先のまま維持される。
  #
  # 内蔵マイク以外なら戻す方式なので、AirPods / soundcore 等の Bluetooth も、
  # 有線 EarPods (3.5mm ジャック) も、機種名に依存せずまとめて対象になる。
  # 判定・指定ともに UID を使うため、表示名がロケールで変わっても壊れない。
  #
  # ProcessType は指定しない。"Background" にすると launchd のタイマー結合で
  # StartInterval が大幅に間引かれ、30 秒間隔が実際には数分〜数十分に伸びる。
  #
  # 常駐プロセスは持たず、launchd が 30 秒ごとに一度だけ実行する。
  launchd.user.agents.force-builtin-mic = lib.mkIf enableSwitchAudio {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        ''
          current=$(${pkgs.switchaudio-osx}/bin/SwitchAudioSource -c -t input -f json)
          case "$current" in
            *BuiltInMicrophoneDevice*)
              ;;
            *)
              ${pkgs.switchaudio-osx}/bin/SwitchAudioSource -t input -u BuiltInMicrophoneDevice
              ;;
          esac
        ''
      ];
      StartInterval = 30;
      RunAtLoad = true;
    };
  };
}
