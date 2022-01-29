{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.homies.configs.fzf;
in
{
  options.homies.configs.fzf.enable = mkEnableOption "fzf configuration";

  config = mkIf cfg.enable {
    home.sessionVariables = {
      "FZF_DEFAULT_COMMAND" =
        "$pkgs.ripgrep}/bin/rg --files --hidden --follow -g \"!{.git}\" 2>/dev/null";
      "FZF_CTRL_T_COMMAND" = config.home.sessionVariables."FZF_DEFAULT_COMMAND";
      "FZF_DEFAULT_OPS" = "";
    };

    programs.fzf.enable = true;
  };
}
