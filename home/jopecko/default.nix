{ inputs, lib, username, persistence, features, ... }: {
  imports = [
    ./cli
    ./rice # Race Inspired Cosmetic Enhancements
    inputs.impermanence.nixosModules.home-manager.impermanence
  ]
  # Import features that have modules
  ++ builtins.filter builtins.pathExists (map (feature: ./${feature}) features);

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    inherit username;
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "22.05";
    homeDirectory = "/home/${username}";
    sessionVariables = {
      NIX_CONFIG = "experimental-features = nix-command flakes";
    };
    persistence = lib.mkIf persistence {
      "/persist/home/jopecko" = {
        directories = [
          "Documents"
          "Downloads"
          "Pictures"
          "Videos"
        ];
        allowOther = true;
      };
    };
  };
}
