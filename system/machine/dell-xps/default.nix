{ config, pkgs, ... }:

{
  imports = [
    # Hardware scan
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    interfaces = {
      wlp114s0.useDHCP = true;
    };
  };
}
