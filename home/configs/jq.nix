{ config, lib, ... }:

with lib;
let
  cfg = config.homies.configs.jq;
in
{
  options.homies.configs.jq.enable = mkEnableOption "jq configuration";

  config = mkIf cfg.enable {
    programs.jq.enable = true;
  };
}
