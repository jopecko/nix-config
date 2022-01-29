{ config, pkgs, lib, ... }:

{
  users.users = {
    jopecko = {
      isNormalUser = true;
      home = "/home/jopecko";
      extraGroups = [
        "wheel"
        "networkmanager"
        "lp"
      ];
    };
  };
}
