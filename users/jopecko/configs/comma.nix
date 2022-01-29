{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.homies.configs.comma;
  comma = import (pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "4a62ec17e20ce0e738a8e5126b4298a73903b468";
    sha256 = "0n5a3rnv9qnnsrl76kpi6dmaxmwj1mpdd2g0b4n1wfimqfaz6gi1";
  }) {};

in
{
  options.homies.configs.comma.enable = mkEnableOption "comma configuration";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [comma];
  };
}
