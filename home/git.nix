{ config, pkgs, ... }:

{
  # Git
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
  # Aliases config in ./configs/git-aliases.nix
  programs.git.enable = true;

  programs.git.extraConfig = {
    diff.colorMoved = "default";
    pull.rebase = true;
    core.editor = "vim -f";
    core.excludesfile = "~/.global_gitignore";
    gpg.format = "ssh";
    gpg = {
      "ssh" = {
        program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
    };
    commit.gpgsign = true;
  };

  programs.git.signing = {
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVRZRGT9vmdx4jN9vVsKfdTZHF4TWx9eo5lqetrnfAn";
  };

  programs.git.ignores = [
    ".DS_Store"
    "myscripts/*"
  ];

  programs.git.userEmail = config.home.user-info.email;
  programs.git.userName = config.home.user-info.fullName;

  # Enhanced diffs
  programs.git.delta.enable = true;


  # GitHub CLI
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.gh.enable
  # Aliases config in ./gh-aliases.nix
  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";
}
