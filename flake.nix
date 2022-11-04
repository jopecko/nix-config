{
  description = "NixOS configuration";

  inputs = {
    # Nix ecossystem
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/NUR";
    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tex2nix = {
      url = github:Mic92/tex2nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      lib = import ./lib { inherit inputs; };
      inherit (lib) mkSystem mkHome mkDeploys forAllSystems mkDarwinSystem;
    in
    rec {
      inherit lib;

      overlays = {
        default = import ./overlay { inherit inputs; };
        nur = inputs.nur.overlay;
        hyprland = inputs.hyprland.overlays.default;
        hyprwm-contrib = inputs.hyprwm-contrib.overlays.default;
        neovim-nightly-overlay = inputs.neovim-nightly-overlay.overlay;
        sops-nix = inputs.sops-nix.overlay;
      };

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      templates = import ./templates;

      devShells = forAllSystems (system: {
        default = legacyPackages.${system}.callPackage ./shell.nix { };
      });

      apps = forAllSystems (system: rec {
        deploy = {
          type = "app";
          program = "${legacyPackages.${system}.deploy-rs}/bin/deploy";
        };
        default = deploy;
      });

      legacyPackages = forAllSystems (system:
        import inputs.nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        }
      );

      nixosConfigurations = {
        # Dell XPS
       ikaika = mkSystem {
         hostname = "ikaika";
         pkgs = legacyPackages."x86_64-linux";
         persistence = false;
       };
      };

      homeConfigurations = {
        # Dell XPS
        "jopecko@ikaika" = mkHome {
          username = "jopecko";
          hostname = "ikaika";
          persistence = false;

          features = [
            "desktop/hyprland"
            "laptop"
            "trusted"
          ];
          colorscheme = "spaceduck";
          wallpaper = "aurora-borealis-water-mountain";
        };
      };

      darwinConfigurations = {
        # CB Laptop
        jopecko-mb = mkDarwinSystem {
          hostname = "jopecko-mb";
          pkgs = legacyPackages."x86_64-darwin";
        };
      };

      deploy = {
        nodes = mkDeploys nixosConfigurations homeConfigurations;
        magicRollback = true;
        autoRollback = true;
      };

      deployChecks = { };
    };
}
