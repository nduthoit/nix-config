{ config, lib, pkgs, ... }:

let
  nixConfigDirectory = config.home.user-info.nixConfigDirectory;

  # Output style name -> upstream raw URL. Single source of truth: drives the
  # `update-claude-output-styles` command below, and records where each vendored file
  # came from. The vendored copies are kept byte-identical to upstream so that updating
  # is a plain overwrite and the diffs stay readable.
  #
  # AminBlg/SimpleEnglish is MIT licensed.
  outputStyleSources = {
    simple-english =
      "https://raw.githubusercontent.com/AminBlg/SimpleEnglish/main/output-styles/simple-english.md";
  };

  # Re-download every vendored output style, then show what changed.
  updateOutputStyles = pkgs.writeShellApplication {
    name = "update-claude-output-styles";
    runtimeInputs = [ pkgs.curl pkgs.git ];
    text = ''
      dir="${nixConfigDirectory}/claude/output-styles"
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: url: ''
        echo "==> ${name}"
        curl -fsSL ${lib.escapeShellArg url} -o "$dir/${name}.md"
      '') outputStyleSources)}
      git -C "${nixConfigDirectory}" --no-pager diff --stat -- claude/output-styles
      echo "Review the diff above, then run: drs"
    '';
  };
in

{
  home.packages = [ updateOutputStyles ];

  # Claude Code's user settings -- the `userSettings` source in its settings cascade,
  # which resolves to `~/.claude/settings.json`. The active output style is the
  # `outputStyle` key in that file.
  #
  # Symlinked to the working copy rather than a `/nix/store` path because Claude Code
  # writes to this file itself: `/model` and `/theme` changes land here, and a read-only
  # store source would break them. The trade-off is that those writes show up as git
  # churn in this repo.
  home.activation.linkClaudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    _src="${nixConfigDirectory}/claude/settings.json"
    _dst="$HOME/.claude/settings.json"
    $DRY_RUN_CMD mkdir -p "$(dirname "$_dst")"
    $DRY_RUN_CMD ln -sfn "$_src" "$_dst"
  '';

  # Claude Code parses every `*.md` in this directory as an output style, so only style
  # files belong here. `recursive = true` symlinks each file individually, leaving any
  # style that Claude Code or a plugin drops in alongside them untouched.
  home.file.".claude/output-styles" = {
    source = ../claude/output-styles;
    recursive = true;
  };
}
