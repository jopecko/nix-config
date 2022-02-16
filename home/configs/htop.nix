{ config, lib, ... }:

with lib;
let
  cfg = config.homies.configs.htop;
in
{
  options.homies.configs.htop.enable = mkEnableOption "htop configuration";

  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;
      #detailedCpuTime = true;
      #showThreadNames = true;
      #treeView = true;
    };
  };
}
