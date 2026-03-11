{ config, pkgs, ... }:

{
  # Git
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
  # Aliases config in ./configs/git-aliases.nix
  programs.git.enable = true;

  programs.git.settings = {
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
    advice.defaultBranchName = false;
  };

  programs.git.signing = {
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILVRZRGT9vmdx4jN9vVsKfdTZHF4TWx9eo5lqetrnfAn";
  };

  programs.git.ignores = [
    ".DS_Store"
    "myscripts/*"
  ];

  programs.git.settings.user.email = config.home.user-info.email;
  programs.git.settings.user.name = config.home.user-info.fullName;

  # Enhanced diffs
  programs.delta.enable = true;
  programs.delta.enableGitIntegration = true;


  # GitHub CLI
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.gh.enable
  # Aliases config in ./gh-aliases.nix
  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";
}
