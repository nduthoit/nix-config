{ config, lib, ... }:

let
  nixConfigDirectory = config.home.user-info.nixConfigDirectory;
in

{
  # Claude Code's user settings -- the `userSettings` source in its settings cascade,
  # which resolves to `~/.claude/settings.json`.
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
}
