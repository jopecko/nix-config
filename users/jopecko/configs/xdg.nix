{ config, lib, ... }:

with lib;
let
  cfg = config.homies.configs.xdg;
in
{
  options.homies.configs.xdg.enable = mkEnableOption "xdg configuration";

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      #mime.enable = true;
    };
  };
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap