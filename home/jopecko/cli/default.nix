{ pkgs, lib, ... }: {
  imports = [
    ./bash
    ./bat.nix
    ./fish.nix
    ./fzf.nix
    ./git
    ./nvim
    ./screen.nix
    ./ssh.nix
  ] ++ lib.optionals pkgs.stdenvNoCC.isLinux [
    ./amfora.nix
    ./nix-index.nix
    ./pfetch.nix
    ./ranger.nix
    ./shellcolor.nix
    ./starship.nix
  ];
  home.packages = with pkgs; [
    act
    binutils
    comma # Install and run programs by sticking a , before them
    curl
    exa # better ls
    fd  # better find
    feh
    file
    graphviz
    hexyl
    htop
    httpie # better curl
    inetutils # telnet
    jq
    jwt-cli
    killall
    kubectl
    k9s
    nix-prefetch-git
    pgcli
    ripgrep
    tmux
    ugrep # better grep
    wget
  ] ++ lib.optionals pkgs.stdenvNoCC.isLinux [
    distrobox # Nice escape hatch, integrates docker images with my environment
    bottom # System viewer
    ncdu # TUI disk usage
    trekscii # Cute startrek cli printer
    deploy-rs # Deployment tool
    sops # Deployment secrets tool
    nixfmt # Nix formatter
    nvd nix-diff # Check derivation differences
    haskellPackages.nix-derivation # Inspecting .drv's
    dconf
  ] ++ lib.optional pkgs.stdenvNoCC.isDarwin kitty;
}
