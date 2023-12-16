{ lib , pkgs , config , username , ...  }:

{
  services.yabai = {
    enable = true;

    config = {
      # bar settings
      status_bar                   = "off";
      status_bar_text_font         = "Helvetica Neue:Regualar:12.0";
      status_bar_icon_font         = "FuraMono Nerd Font:Regular:14.0";
      #status_bar_background_color  = "0xff101010";
      #status_bar_foreground_color  = "0xfff0f0f0";
      #status_bar_space_icon_strip  = "   I II III IV V VI VII";
      #status_bar_power_icon_strip  = " ";
      #status_bar_space_icon        = "";
      #status_bar_clock_icon        = "";

      # global settings
      mouse_follows_focus          = "off";
      focus_follows_mouse          = "autofocus";
      window_placement             = "second_child";
      window_topmost               = "off";
      window_opacity               = "on";
      window_opacity_duration      = 0.0;
      window_shadow                = "on";
      window_border                = "off";
      window_border_width          = 1;
      active_window_border_color   = "0xffb2b2b2";
      normal_window_border_color   = "0xff202020";
      insert_window_border_color   = "0xffd75f5f";
      active_window_opacity        = 1.0;
      normal_window_opacity        = 1.0;
      split_ratio                  = 0.50;
      auto_balance                 = "off";
      mouse_modifier               = "fnu";
      mouse_action1                = "move";
      mouse_action2                = "resize";

      # general space settings
      layout                       = "bsp";
      top_padding                  = 10;
      bottom_padding               = 10;
      left_padding                 = 10;
      right_padding                = 10;
      window_gap                   = 10;
    };

    extraConfig = ''
      yabai -m rule --add app='Activity Monitor'    manage=off
      yabai -m rule --add app='App Store'           manage=off
      yabai -m rule --add app='Authy Desktop'       manage=off
      yabai -m rule --add app='BBEdit'              manage=off
      yabai -m rule --add app='Boot Camp Assistant' manage=off
      yabai -m rule --add app='Discord'             manage=off
      yabai -m rule --add app='Finder'              manage=off
      yabai -m rule --add app='IntelliJ IDEA'       manage=off
      yabai -m rule --add app='Keybase'             manage=off
      yabai -m rule --add app='Milkshake'           manage=off
      yabai -m rule --add app='PhotoBooth'          manage=off
      yabai -m rule --add app='Sketchybar'          manage=off
      yabai -m rule --add app='Slack'               manage=off
      yabai -m rule --add app='Sourcetree'          manage=off
      yabai -m rule --add app='Spotify'             manage=off
      yabai -m rule --add app='Swiftbar'            manage=off
      yabai -m rule --add app='System Information'  manage=off
      yabai -m rule --add app='System Settings'     manage=off
      yabai -m rule --add app='TextEdit'            manage=off
      yabai -m rule --add app='VirtualBox'          manage=off
      yabai -m rule --add app='WhatsApp'            manage=off
      yabai -m rule --add app='Zoom'                manage=off
      yabai -m rule --add app='zoom.us'             manage=off
    '';
  };

  # The scripting addition needs root access to load, which we want to do automatically when logging in.
  # Disable the password requirement for it so that a service can do so without user interaction.
  environment.etc."sudoers.d/yabai-load-sa".text = ''
    ${username} ALL = (root) NOPASSWD: sha256:${builtins.hashFile "sha256" "${pkgs.yabai}/bin/yabai"} ${pkgs.yabai}/bin/yabai
  '';

  launchd.user.agents.yabai-load-sa = {
    path = [ pkgs.yabai config.environment.systemPath ];
    command = "/usr/bin/sudo ${pkgs.yabai}/bin/yabai --load-sa";
    serviceConfig.RunAtLoad = true;
  };
}
