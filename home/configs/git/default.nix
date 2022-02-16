{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.homies.configs.git;

  gitalias = pkgs.fetchFromGitHub {
    owner = "GitAlias";
    repo = "gitalias";
    rev = "fb19fde1e4ec901ae7e54ef5b1c40d55cab7e86f";
    sha256 = "0axf8s6j1dg2jp637p4zs98h3a5wma5swqfld9igmyqpghpsgx5q";
  };
in
{
  options.homies.configs.git = {
    enable = mkEnableOption "git configuration";

    email = mkOption {
      type = types.str;
      default = config.homies.configs.mail.email;
      description = "Email used in authoring Git commits.";
    };

    name = mkOption {
      type = types.str;
      default = config.homies.configs.mail.name;
      description = "Name used in authoring Git commits.";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      aliases = {
        stash-unapply = "!git stash show -p | git apply -R";
        ci = "commit --verbose";
        amend = "commit --amend --reuse-message=HEAD";
        aa = "add --all";
        ff = "merge --ff-only";
        noff = "merge --no-ff";
        fa = "fetch --all";
        ds = "diff --stat=160,120";
        br = "branch";
        co = "checkout";
        df = "diff";
        dc = "diff --cached";
        lg = "log -p";
        lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        ls = "ls-files";
        rso = "remote show origin";

        # fetch a PR from origin
        fpr = "!sh -c 'git fetch origin pull/$1/head:pr-$1' -";

        # view abbreviated SHA, description, and history graph of latest 20 commits
        l = "log --pretty=oneline -n 20 --graph --abbrev-commit";

        # view the current working tree status using the short format
        s = "status -s";

        # Show the diff between the latest commit and the current state
        d = "!\"git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat\"";

        # `git di $number` shows the diff between the state `$number` revisions ago and current state
        di = "!\"d() { git diff --patch-with-stat HEAD~$1; }; git diff-index --quiet HEAD -- || clear; d\"";

        # Checkout a pull request from origin (of a github repo)
        pr = "!\"pr() { git fetch origin pull/$1/head:pr-$1; git checkout pr-$1; }; pr\"";

        # Clone a repository including all submodules
        c = "clone --recursive";

        # Pull in remote changes for the current repository and all its submodules
        p = "!\"git pull; git submodule foreach git pull origin master\"";

        # Commit all changes
        ca = "!git add -A && git commit -av";

        # Switch to a branch, creating if necessary
        go = "!f() { git checkout -b \"$1\" 2 > /dev/null || git checkout \"$1\"; }; f";

        # Color graph log view
        graph = "log --graph --color --pretty=format:\"%C(yellow)%H%C(green)%d%C(reset)%n%x20%cd%n%x20%cn%x20(%ce)%n%x20%s%n\"";

        # Show verbose output about tags, branches, or remotes
        tags = "tag -1";
        branches = "branch -a";
        remotes = "remote -v";

        # Credit an author on the latest commit
        credit = "!f() { git commit --amend --author \"$1 <$2>\" -C HEAD; }; f";

        # Interactive rebase with the given number of latest commits
        reb = "!r() { git rebase -i HEAD~$1; }; r";

        # Find branches containing commit
        fb = "!f() { git branch -a --contains $1; }; f";

        # Find tags containing commit
        ft = "!f() { git describe --always --contains $1; }; f";

        # Find commits by source code
        fc = "\"!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short -S$1; }; f\"";

        # Find commits by commit message
        fm = "\"!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short --grep=$1; }; f\"";

        # Remove branches that have already been merged with master
        # a.k.a. ‘delete merged’
        dm = "\"!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d; git remote -v update -p\"";

        # List contributors with number of commits
        contributors = "shortlog --summary --numbered";

        # from seth vargo https://gist.github.com/sethvargo/6b2f7b592853381690bfe3bd00947e8f
        unreleased = "\"!f() { git fetch --tags && git diff $(git tag | tail -n 1); }; f\"";
        up = "!git pull origin master && git remote prune origin && git submodule update --init --recursive";
        undo = "!git reset HEAD~1 --mixed";
        top = "!git log --format=format:%an | sort | uniq -c | sort -r | head -n 2";

        # from trevor bramble https://twitter.com/TrevorBramble/status/774292970681937920
        alias = "!git config -l | grep ^alias | cut -c 7- | sort";

        # Debug a command or alias - preceed it with `debug`
        debug = "!set -x; GIT_TRACE=2 GIT_CURL_VERBOSE=2 GIT_TRACE_PERFORMANCE=2 GIT_TRACE_PACK_ACCESS=2 GIT_TRACE_PACKET=2 GIT_TRACE_PACKFILE=2 GIT_TRACE_SETUP=2 GIT_TRACE_SHALLOW=2 git";
        # Quote / unquote a sh command, converting it to / from a git alias string
        quote-string = "!read -r l; printf \\\"!; printf %s \"$l\" | sed 's/\\([\\\"]\\)/\\\\\\1/g'; printf \" #\\\"\\n\" #";
        quote-string-undo = "!read -r l; printf %s \"$l\" | sed 's/\\\\\\([\\\"]\\)/\\1/g'; printf \"\\n\" #";
        # Push commits upstream.
        ps = "push";
        # Overrides gitalias.txt `save` to include untracked files.
        save = "stash save --include-untracked";
        st = "status";
      };
      extraConfig = {
        color = {
          ui = "auto";
          branch = {
            current = "yellow reverse";
            local = "yellow";
            remote = "green";
          };
          diff = {
            whitespace = "reverse red";
            meta = "yellow bold";
            frag = "magenta bold";
            old = "red bold";
            new = "green bold";
          };
          status = {
            added = "yellow";
            changed = "green";
            untracked = "cyan";
          };
        };
        commit = {
          verbose = true;
          # template = "${config.xdg.dataHome}/git/template";
        };
        core = {
          # editor = config.home.sessionVariables."EDITOR";
          whitespace = "fix,space-before-tab,-indent-with-non-tab,trailing-space,cr-at-eol";
          editor = "vi";
        };
        diff = {
          compactionHeuristic = true;
          indentHeuristic = true;
          renames = "copies";
        };
        branch.autosetuprebase = "always";
        help.autocorrect = 1;
        format.pretty = "%C(yellow)%h%Creset %s %C(red)(%cr)%Creset";
        push = {
          default = "tracking";
          followTags = true;
        };
        status.showStash = true;
        stash.showPatch = true;
        submodule.fetchJobs = 4;
        rebase.autosquash = true;
        user.useConfigOnly = true;
        merge = {
          tool = "opendiff";
          summary = true;
          commit = "no";
          #ff = "no";
          log = true;
          conflictstyle = "diff3";
        };
        init.defaultBranch = "main";
      };
      ignores = [ (builtins.readFile ./ignore) ];
      includes = [{ path = "${gitalias}/gitalias.txt"; }];
      package = pkgs.gitAndTools.gitFull;
      userEmail = "jopecko@users.noreply.github.com"; # cfg.email
      userName = "Joe O'Pecko"; # cfg.name
    };
  };
}
