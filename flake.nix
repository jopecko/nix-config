{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nikpkgs.follows = "nixpkgs";
    };

    nurpkgs = {
      url = github:nix-community/NUR;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = github:NixOS/nixos-hardware/master;

    tex2nix = {
      url = github:Mic92/tex2nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nixos-hardware, nurpkgs, tex2nix }:
    let
      system = "x86_64-linux";
    in
    {
      homeConfigurations = {
        import ./outputs/home-conf.nix {
          inherit system nixpkgs home-manager nurpkgs tex2nix;
        }
      };

      nixosConfigurations = {
#        ikaika = nixpkgs.lib.nixosSystem {
#          inherit system;
#          specialArgs = { inherit inputs; };
#          modules = [
#            # ./machine/dell-xps13
#            nixos-hardware.nixosModules.dell-xps-13-9310
#            ./configuration.nix
#          ];
#        };
#      };
      import ./outputs/nixos-conf.nix {
        inherit inputs system
      }
    };
}
