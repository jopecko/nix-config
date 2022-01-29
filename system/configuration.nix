{ config, pkgs, ... }:

{

  imports = [
    ./wm/i3.nix
  ];

  networking = {
    networkmanager.enable = true;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behavior.
    useDHCP = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firejail # restrict running env of untrusted apps using lxc
    vim
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # enable Docker and VirtualBox support
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    virtualbox.host = {
      enable = true;
    };
  };

  users.extraGroups.vboxusers.members = [ "jopecko" ];

  # enable sound
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraConfig = ''
      load-module module-switch-on-connect
    '';
  };

  services = {
    # Enable the OpenSSH daemon
    openssh.enable = true;

    # SSH daemin
    sshd.enable = true;

    # Enable CUPS
    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
  };

  users.users.jopecko = {
    isNormalUser = true;
    extraGroups = [ "docker" "networkmanager" "wheel" "lp" ];
  };

  nixpkgs.config.allowUnfree = true;

  # Nix daemon config
  nix = {
    # Automate `nix-store --optimize`
    autoOptimiseStore = true;

    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # Avoid unwanted garbage collection when using nix-direnv
    extraOptions = ''
      keep-outputs     = true
      keep-derivations = true
    '';

    # required by Cachix to be used as non-root user
    trustedUsers = [ "root" "jopecko" ];
  };

  security = {
    sudo.configFile = ''
      Defaults lecture=always
      Defaults lecture_file=${../../misc/groot.txt}
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

