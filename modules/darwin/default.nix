{ pkgs, config, nixpkgs, username , ...  }:

{
  services.nix-deamon.enable = true;

  fonts = {
    fontDir.enable = true;

    fonts = with pkgs; [
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  }
}
