{ config, lib, pkgs, ... }:

{
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  services = {
    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = true;
      };

      displayManager = {
        defaultSession = "none+i3";
      };

      # https://nixos.wiki/wiki/I3
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
        ];
      };
    };
  };
}
