{ lib, ... }:

{
  imports = [
    ./common.nix
  ];

  config.homies.profiles.common.enable = lib.mkDefault true;
}