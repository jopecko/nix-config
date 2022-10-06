{ config, persistence, lib, ... }: {
  networking.wireless = {
    enable = true;

    allowAuxiliaryImperativeNetworks = true;
    userControlled = {
      enable = true;
      group = "network";
    };
    extraConfig = ''
      ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=network
      update_config=1
    '';
  };

  # Ensure group exists
  users.groups.network = { };

  # Persist imperative config
  environment.persistence = lib.mkIf persistence {
    "/persist".files = [
      "/etc/wpa_supplicant.conf"
    ];
  };
}
