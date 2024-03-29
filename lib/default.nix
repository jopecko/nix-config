{ inputs, ... }:
let
  inherit (inputs) self home-manager nixpkgs deploy-rs;
  inherit (self) outputs;

  inherit (builtins) elemAt match any mapAttrs attrValues attrNames listToAttrs;
  inherit (nixpkgs.lib) nixosSystem filterAttrs genAttrs mapAttrs';
  inherit (home-manager.lib) homeManagerConfiguration;

  activate = type: config: deploy-rs.lib.${config.pkgs.system}.activate.${type} config;
in
rec {
  # Applies a function to a attrset's names, while keeping the values
  mapAttrNames = f: mapAttrs' (name: value: { name = f name; inherit value; });

  has = element: any (x: x == element);

  getUsername = string: elemAt (match "(.*)@(.*)" string) 0;
  getHostname = string: elemAt (match "(.*)@(.*)" string) 1;

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "i686-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];
  forAllSystems = genAttrs systems;

  mkSystem =
    { hostname
    , pkgs
    , persistence ? false
    }:
    nixosSystem {
      inherit pkgs;
      specialArgs = {
        inherit inputs outputs hostname persistence;
      };
      modules = attrValues (import ../modules/nixos) ++ [ ../hosts/${hostname} ];
    };

  mkHome =
    { username
    , hostname ? null
    , pkgs ? outputs.nixosConfigurations.${hostname}.pkgs
    , persistence ? false
    , colorscheme ? null
    , wallpaper ? null
    , features ? [ ]
    }:
    homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs outputs hostname username persistence
          colorscheme wallpaper features;
      };
      modules = attrValues (import ../modules/home-manager) ++ [ ../home/${username} ];
    };

  mkDeploys = nixosConfigs: homeConfigs:
    let
      nixosProfiles = mapAttrs mkNixosDeployProfile nixosConfigs;
      homeProfiles = mapAttrs mkHomeDeployProfile homeConfigs;
      hostnames = attrNames nixosProfiles;

      homesOn = hostname: filterAttrs (name: _: (getHostname name) == hostname) homeProfiles;
      systemOn = hostname: { system = nixosProfiles.${hostname}; };
      profilesOn = hostname: (systemOn hostname) // (mapAttrNames getUsername (homesOn hostname));
    in
    listToAttrs (map
      (hostname: {
        name = hostname;
        value = {
          inherit hostname;
          profiles = profilesOn hostname;
        };
      })
      hostnames);


  mkNixosDeployProfile = _name: config: {
    user = "root";
    path = activate "nixos" config;
  };

  mkHomeDeployProfile = name: config: {
    user = getUsername name;
    path = activate "home-manager" config;
  };
}
