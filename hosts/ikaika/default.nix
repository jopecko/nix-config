# System configuration for my Dell XPS 13
{ pkgs, inputs, lib, ... }: {
  imports = [
    inputs.hardware.nixosModules.dell-xps-13-9310

    ./hardware-configuration.nix
    ../common/global
    ../common/users/jopecko.nix

    # ../common/optional/acme.nix
    # ../common/optional/podman.nix
    # ../common/optional/postgres.nix
    # ../common/optional/tailscale.nix
    ../common/optional/wireless.nix
    # ./services
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

    # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # firejail # restrict running env of untrusted apps using lxc
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    # wget
    virt-manager
  ];

  virtualisation.libvirtd = {
    enable = true;
  };

  services.dbus.packages = [ pkgs.gcr ];

  powerManagement.powertop.enable = true;

  programs = {
    light.enable = true;
    adb.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
  };

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
