{ pkgs ? null }: {

  # Packages with an actual source
  gtklock = pkgs.callPackage ../gtklock { };
  rgbdaemon = pkgs.callPackage ../rgbdaemon { };
  shellcolord = pkgs.callPackage ../shellcolord { };
  swayfader = pkgs.callPackage ../swayfader { };
  trekscii = pkgs.callPackage ../trekscii { };

  # Personal scripts
  pass-wofi = pkgs.callPackage ../pass-wofi { };
  primary-xwayland = pkgs.callPackage ../primary-xwayland { };
  wl-mirror-pick = pkgs.callPackage ../wl-mirror-pick { };
  lyrics = pkgs.callPackage ../lyrics { };
}
