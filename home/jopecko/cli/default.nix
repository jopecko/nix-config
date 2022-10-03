{ pkgs, ... }: {
  imports = [
    ./amfora.nix
    ./bash
    ./bat.nix
    ./fish.nix
    ./git
    ./nix-index.nix
    ./nvim
    ./pfetch.nix
    ./ranger.nix
    ./screen.nix
    ./shellcolor.nix
    ./ssh.nix
    ./starship.nix
  ];
  home.packages = with pkgs; [
    comma # Install and run programs by sticking a , before them
    distrobox # Nice escape hatch, integrates docker images with my environment

    bc # Calculator
    bottom # System viewer
    ncdu # TUI disk usage
    exa # Better ls
    ugrep # Better grep
    fd # Better find
    httpie # Better curl
    jq # JSON pretty printer and manipulator
    trekscii # Cute startrek cli printer

    deploy-rs # Deployment tool
    sops # Deployment secrets tool

    nixfmt # Nix formatter
    nvd nix-diff # Check derivation differences
    haskellPackages.nix-derivation # Inspecting .drv's

    dconf
  ];
}
