{ config, lib, ... }:

with lib;
let
  cfg = config.homies.configs.ssh;
in
{
  options.homies.configs.ssh.enable = mkEnableOption "ssh configuration";

  config = mkIf cfg.enable {

    programs.ssh = {
      compression = true;
      enable = true;
      controlMaster = "auto";
      controlPath = "${config.home.homeDirectory}/.ssh/sockets/%r@%h-%p";
      controlPersist = "600";
      extraConfig = ''
        VisualHostKey no
        PasswordAuthentication no
        ChallengeResponseAuthentication no
        StringHostKeyChecking ask
        VerifyHostKetDNS yes
        ForwardX11 no
        ForwardX11Trusted no
        ServerAliveCountMax 2
      '';
      extraOptionOverrides = {
        "Include" = "${config.home.homeDirectory}/.ssh/config.local";
      };
      forwardAgent = false;
      hashKnownHosts = true;
      serverAliveInterval = 300;
    };
  };
}
