{ persistence, outputs, lib, ... }:

let
  hosts = builtins.attrNames outputs.nixosConfigurations;
  sshPath = if persistence then "/persist/etc/ssh" else "/etc/ssh";
in
{
  services.openssh = {
    enable = true;
    # Harden
    passwordAuthentication = false;
    permitRootLogin = "no";
    # Automatically remove stale sockets
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
    # Allow forwarding ports to everywhere
    gatewayPorts = "clientspecified";

    hostKeys = [
      {
        bits = 4096;
        path = "${sshPath}/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "${sshPath}/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.ssh = {
    # Each hosts public key
    knownHostsFiles = lib.flatten (map
      (host: [
        ../../${host}/ssh_host_ed25519_key.pub
        ../../${host}/ssh_host_rsa_key.pub
      ])
      hosts);
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;
}
