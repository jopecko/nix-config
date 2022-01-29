{ config, pkgs, lib, ... }:

let home_dir = builtins.getEnv "HOME";
    username = builtins.getEnv "USER";
    callPackage = pkgs.callPackage;

    relativeXDGConfigPath = ".config";
    relativeXDGDataPath = ".local/share";
    relativeXDGCachePath = ".cache";

    LS_COLORS = pkgs.fetchgit {
      url = "https://github.com/trapd00r/LS_COLORS";
      rev = "6fb72eecdcb533637f5a04ac635aa666b736cf50";
      sha256 = "0czqgizxq7ckmqw9xbjik7i1dfwgc1ci8fvp1fsddb35qrqi857a";
    };
    ls-colors = pkgs.runCommand "ls-colors" { } ''
      mkdir -p $out/bin $out/share
      ln -s ${pkgs.coreutils}/bin/ls $out/bin/ls
      ln -s ${pkgs.coreutils}/bin/dircolors $out/bin/dircolors
      cp ${LS_COLORS}/LS_COLORS $out/share/LS_COLORS
    '';

in {

  imports =
    ( builtins.filter builtins.pathExists [ ./home-private.nix ] ) ++ [
      ( import ./configs )
      ( import ./profiles )
    ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
    };
    overlays = [
      (import ./overlays/coc-nvim)
    ];
  };

  home = {
    packages = [
      # Customized packas
      ls-colors

      # Sourced directly from Nixpkgs
      pkgs.curl
      #pkgs.htop
      pkgs.jq
      pkgs.pass
      pkgs.tree
      #pkgs.vscode
    ];

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "21.11";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    broot.enable = true;
    #gpg.enable = true;

    # neovim = {
    #   enable = true;
    #   vimAlias = true;
    #   #extraConfig = builtins.readFile ./home/extraConfig.vim;

    #   plugins = with pkgs.vimPlugins; [
    #     # Syntax / Language Support ##########################
    #     vim-nix
    #     vim-ruby
    #     vim-go
    #     rust-vim
    #     vim-pandoc
    #     vim-pandoc-syntax

    #     # UI #################################################
    #     #gruvbox # colorscheme
    #     #vim-gutter # status in gutter
    #     vim-airline

    #     # Editor Features ####################################
    #     vim-surround
    #     vim-repeat
    #     vim-commentary
    #     vim-indent-object
    #     vim-easy-align
    #     vim-eunuch
    #     vim-sneak
    #     supertab
    #     ale
    #     nerdtree

    #     # Buffer / Pane / File Management #####################
    #     fzf-vim

    #     # Panes / Larget features #############################
    #     tagbar
    #     vim-fugitive
    #   ];
    # };

    #git = {
    #  enable = true;

    #  userName = "Joe O'Pecko";
    #  userEmail = "jopecko@users.noreply.github.com";
    #};
  };
}
