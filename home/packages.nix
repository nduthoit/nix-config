{ lib, pkgs, ... }:

{
  # Bat, a substitute for cat.
  # https://github.com/sharkdp/bat
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.bat.enable
  programs.bat.enable = true;
  programs.bat.config = {
    style = "plain";
  };

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  # SSH
  # https://nix-community.github.io/home-manager/options.html#opt-programs.ssh.enable
  # Some options also set in `../darwin/homebrew.nix`.
  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;
  programs.ssh.matchBlocks = {
    "*" = {
      controlPath = "~/.ssh/%C"; # ensures the path is unique but also fixed length
    };
    "1password-agent" = {
      match = "host * exec \"test -z $SSH_TTY\"";
      extraOptions = {
        IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      };
    };
  };

  # Zoxide, a faster way to navigate the filesystem
  # https://github.com/ajeetdsouza/zoxide
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.zoxide.enable
  programs.zoxide.enable = true;

  home.packages = lib.attrValues ({
    # Some basics
    inherit (pkgs)
      bandwhich # display current network utilization by process
      bottom # fancy version of `top` with ASCII graphs
      coreutils
      curl
      dust # fancy version of `du`
      eza # fancy version of `ls`
      fd # fancy version of `find`
      htop # fancy version of `top`
      hyperfine # benchmarking tool
      mosh # wrapper for `ssh` that better and not dropping connections
      ripgrep # better version of `grep`
      silver-searcher # better grep
      parallel
      tealdeer # rust implementation of `tldr`
      # "unixtools.watch"
      wget
    ;

    # Dev stuff
    inherit (pkgs)
      awscli2
      cloc # source code line counter
      glab
      helix
      jq
      mani
      nodejs
      poppler-utils
      python3
      tmux
      typescript
      shellcheck
      uv
      yq
    ;

    # Useful nix related tools
    inherit (pkgs)
      cachix # adding/managing alternative binary caches hosted by Cachix
      comma # run software from without installing it
      nix-output-monitor # get additional information while building packages
      nix-tree # interactively browse dependency graphs of Nix derivations
      nix-update # swiss-knife for updating nix packages
      nixpkgs-review # review pull-requests on nixpkgs
      statix # lints and suggestions for the Nix programming language
    ;

  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    nerd-fonts-symbols = pkgs.nerd-fonts.symbols-only;

    inherit (pkgs)
      m-cli # useful macOS CLI commands
      # prefmanager # tool for working with macOS defaults
    ;
  });
}
