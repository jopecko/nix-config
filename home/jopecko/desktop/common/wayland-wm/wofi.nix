{ config, lib, pkgs, ... }:
let
  pass-wofi = pkgs.pass-wofi.override {
    pass = config.programs.password-store.package;
  };
in
{
  home = {
    packages = with pkgs; [
      wofi
      pass-wofi
    ];

    preferredApps.menu = {
      run-cmd = "wofi -S run";
      drun-cmd = "wofi -S drun -x 10 -y 10 -W 25% -H 60%";
      dmenu-cmd = "wofi -S dmenu";
      password-cmd = "pass-wofi";
    };
  };

  xdg.configFile."wofi/config".text = ''
    image_size=48
    columns=3
    allow_images=true
    insensitive=true
    term=${config.home.preferredApps.terminal.cmd}

    run-always_parse_args=true
    run-cache_file=/dev/null
    run-exec_search=true
  '';
}
