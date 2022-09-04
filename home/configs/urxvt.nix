{ config, lib, pkgs, ...}:

with lib;
let
  cfg = config.homies.configs.urxvt;
in
{
  options.homies.configs.uxrvt.enable = mkEnableOption "uxrvt configuration";

  config = mkIf cfg.enable {
    programs.urxvt = {
      enable = true;
      extraConfig = {
        "perl-ext-common" = "default,tabbedex";
        "perl-lib" = "${pkgs.rxvt-unicode}/lib/urxvt/perl";
        "borderLess" = false;
        "externalBorder" = 0;
        "internalBorder" = 4;
        "tabbedex.tabbar-fg" = 15;
        "tabbedex.tabbar-bg" = 236;
        "tabbedex.tab-fg" = 110;
        "tabbedex.tab-bg" = 236;
        "tabbedex.transparent" = true;
        "tabbedex.new-button" = false;
      };
      fonts = [ "xft:DejaVuSansMono:size=10:antitalias=true" ];
      keybindings = ''
        {
          "Shift-Control-N" = "perl:tabbedex:new_tab";
          "Shift-Control-K" = "perl:tabbedex:next_tab";
          "Shift-Control-J" = "perl:tabbedex:prev_tab";
          "Shift-Control-R" = "perl:tabbedex:rename_tab";
          "Shift-Control-H" = "perl:tabbedex:move_tab_left";
          "Shift-Control-L" = "perl:tabbedex:move_tab_right";
        }
      '';
      scroll = {
        bar.enable = false;
        keepPosition = true;
        lines = 10000;
        scrollOnKeystroke = true;
        scrollOnOutput = false;
      };
    };
  }
}
