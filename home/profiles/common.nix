{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.homies.profiles.common;
in
{
  options.homies.profiles.common = {
    enable = mkEnableOption "common configurations";

    # Define a color scheme for use in application configuration to ensure consistency
    colorScheme =
      let
        mkColor = description: default: mkOption {
          inherit default;
          description = "Define the color for ${description}.";
          example = "FFFFF";
          type = types.str;
        };
      in
      {
        background = mkColor "background" "1C1C1C";
        cursor = mkColor "foreground" cfg.colorScheme.foreground;
        foreground = mkColor "foreground" "C5C8C6";

        # Regular colors
        black = mkColor "black" "282A2E";
        red = mkColor "red" "A54242";
        green = mkColor "green" "8C9440";
        yellow = mkColor "yellow" "DE935F";
        blue = mkColor "blue" "5F819D";
        magenta = mkColor "magenta" "85678F";
        cyan = mkColor "cyan" "5E8D87";
        white = mkColor "white" "707880";

        # Bright colours
        brightBlack = mkColor "bright black" "373B41";
        brightRed = mkColor "bright red" "CC6666";
        brightGreen = mkColor "bright green" "B5BD68";
        brightYellow = mkColor "bright yellow" "F0C674";
        brightBlue = mkColor "bright blue" "81A2BE";
        brightMagenta = mkColor "bright magenta" "B294BB";
        brightCyan = mkColor "bright cyan" "8ABEB7";
        brightWhite = mkColor "bright white" "C5C8C6";
      };

    withTools = mkOption {
      type = types.str;
      default = true;
      description = "Install helpful tools and utilities for debugging.";
    };
  };

  config = mkIf cfg.enable {
    home = {
      keyboard.layout = "us";
      language.base = "en_US.utf8";
      packages = with pkgs; [
        # Locales!
        # glibcLocales
        # # Helper script to print the IOMMU groups of PCI devices.
        # # (
        # #   writeScriptBin "list-iommu-groups" ''
        # #     #! ${pkgs.runtimeShell} -e
        # #     shopt -s nullglob
        # #     for g in /sys/kernel/iommu_groups/*; do
        # #       echo "IOMMU Group ''${g##*/}:"
        # #       for d in $g/devices/*; do
        # #         echo -e "\t$(lspci -nns ''${d##*/})"
        # #       done;
        # #     done;
        # #   ''
        # # )
        # Determine file type.
        file
        # Show full path of shell commands.
        which
        # Daemon to execute scheduled commands.
        cron
        # Collection of useful tools that aren't coreutils.
        moreutils
        # Non-interactive network downloader.
        wget
        # List directory contents in tree-like format.
        tree
        # Interactive process viewer.
        htop
        # Top-like I/O monitor.
        # iotop
        # # Power consumption and management diagnosis tool.
        # powertop
        # List hardware.
        # lshw
        # # Collection of programs for inspecting/manipulating configuration of PCI devices.
        # pciutils
        # # Collection of utilities using proc filesystem (`pstree`, `killall`, etc.)
        # psmisc
        # # DMI table decoder.
        # dmidecode
        # # Tools for working with usb devices (`lsusb`, etc.)
        # usbutils
        # # Collection of common network programs.
        # inetutils
        # # Mobile shell with roaming and intelligent local echo.
        # mosh
        # # Bandwidth monitor and rate estimator.
        # bmon
        # DNS server (provides `dig`)
        bind
        # Dump traffic on a network.
        tcpdump
        # Compress/uncompress `.zip` files.
        unzip
        zip
        # Uncompress `.rar` files.
        unrar
        # Man pages
        man
        man-pages
        posix_man_pages
        stdman
        # Arbitrary-precision calculator.
        bc
        # Copy files/archives/repositories into the nix store.
        nix-prefetch-scripts
        # Index the nix store (provides `nix-locate`).
        nix-index
        # Eases nixpkgs review workflow.
        nix-review
        # grep alternative.
        ripgrep
        # ls alternative.
        exa
        # cat alternative.
        bat
        # Quicker access to files and directories.
        fasd
        # GnuPG
        gnupg
        # A command-line tool to generate, analyze, convert and manipulate colors.
        pastel
        # Tool for indexing, slicing, analyzing, splitting and joining CSV files.
        xsv
        # Simple, fast and user-friendly alternative to find.
        fd
        # More intuitive du.
        du-dust
        # cat for markdown
        mdcat
        # Command line image viewer
        viu
        # Tool for discovering and probing hosts on a computer network
        arping
        # Dependency mgmt for nix projects
        niv
        # Visualize Nix gc-roots to delete to free space.
        #nix-du
        # Check which process is using a mountpoint.
        lsof
        # # Encrypted files in Git repositories
        # git-crypt
      ];
      sessionVariables = {
        #"LOCALE_ARCHIVE" = "${pkgs.glibcLocales}/lib/locale/locale-archive";
        #"LANGUAGE" = config.home.language.base;
        #"LC_ALL" = config.home.language.base;

        # Don't clear the screen when leaving man.
        "MANPAGER" = "less -X";
      };
    };

    # Install home-manager manpages.
    manual.manpages.enable = true;

    # Install man output for any Nix packages.
    programs.man.enable = true;

    homies.configs = {
      bash.enable = true;
      comma.enable = true;
      #command-not-found.enable = true;
      #feh.enable = true;
      #fish.enable = true;
      fzf.enable = true;
      git.enable = true;
      #gnupg.enable = true;
      htop.enable = true;
      #hushlogin.enable = true;
      #info.enable = true;
      jq.enable = true;
      #less.enable = true;
      #mail.enable = true;
      #netrc.enable = true;
      neovim.enable = true;
      readline.enable = true;
      #ssh.enable = true;
      #starship.enable = true;
      tmux.enable = true;
      xdg.enable = true;
    };
  };
}
