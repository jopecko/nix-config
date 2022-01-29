{ config, lib, ... }:

with lib;
let
  cfg = config.homies.configs.bash;
in
{
  options.homies.configs.bash.enable = mkEnableOption "GNU Bourne-Again SHell configuration";

  config = mkIf cfg.enable {
    programs.bash = with lib; {
      enable = true;

      historySize = 50000000;

      historyFileSize = 50000000;

      historyControl = [
        "erasedups"
        "ignoredups"
        "ignorespace"
      ];

      historyIgnore = [
        "date"
        "pwd"
        "ls"
        "ll"
        "[bf]g"
        "cd"
        "exit"
        "mkEnableOption"
        "ps"
        "jobs"
        "set"
        "&"
      ];

      sessionVariables = {
        # http://help.github.com/working-with-key-passphrases/
        SSH_ENV = "$HOME/.ssh/environment";
      };

      shellOptions = [
        # Append to history file rather than replacing
        "histappend"

        "histreedit"

        # check the window size after each command and, if
        # necessary, update the values of LINES and COLUMS
        "checkwinsize"

        # Extended globbing
        "extglob"
        "globstar"

        # Warn if closing shell with running jobs
        "checkjobs"

        # Autocorrect typos in path names when using `cd`
        "cdspell"

        # e.g., `**/qux` will enter `./foo/bar/baz/qux`
        "autocd"

        # save multi-line commands in history as single line
        "cmdhist"

        # return files beginning with a dot in path-name expansion
        "dotglob"
      ];

      shellAliases = {
        ls = "ls --color=auto";
        ll = "ls -alFh";
        la = "ls -A";
        l = "ls -CF";

        grep = "grep --color=auto";
        grepp = "ps aux | grep";

        # ff '*.[ch]'
        ff = "find . -follow -name";

        rm = "rm -i";
        cp = "cp -i --backup=numbered";
        mv = "mv -i --backup=numbered";
        mkdir = "mkdir -p";
        ln = "ln -i --backup=numbered";

        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";

        # hunt the disk hog
        duck = "du -cks * | sort -rn | head -11";

        # clear out history
        hclear = "history -c; clear";

        # https://github.com/lihaoyi/Ammonite/issues/607
        amm = "amm --no-remote-logging";

        g = "git status -sb";
        gh = "git hist";
        gp = "git pull";
        gpr = "git pull --rebase";
        gpp = "git pull --rebase && git push";
        gf = "git fetch";
        gb = "git branch";
        ga = "git add";
        gc = "git commit";
        gca = "git commit --amend";
        gcv = "git commit --no-verify";
        gd = "git diff --color-words";
        gdc = "git diff --cached --color-words";
        gdw = "git diff --no-ext-diff --word-diff";
        gl = "git log --oneline --decorate";
        gt = "git tag";
        grc = "git rebase --continue";
        grs = "git rebase --skip";
        gsl = "git stash list";
        gss = "git stash save";

        dip = "docker inspect --format '{{ .NetworkSettings.IPAddress }}'";
        dkd = "docker run -d -P";
        dki = "docker run -t -i -P";

        # Get week number
        week = "date+%V";

        # stopwatch
        timer = "echo \"Timer started. Stop with ^D.\" && date && time cat && date";
      };

      profileExtra = ''
        ${builtins.readFile ./profile}
      '';

      initExtra = ''
        ${builtins.readFile ./bashrc}
      '';
    };
  };
}
