{ config, lib, ... }:

{
  # Zed is installed via the Homebrew cask in `darwin/homebrew.nix`.
  # Global user settings are sourced from `../zed/settings.json`.
  programs.zed-editor.enable = true;
  # Do not install via zed-editor
  programs.zed-editor.package = null;
  programs.zed-editor.mutableUserSettings = true;

  # Pull `programs.mcp.servers` (see ./mcp-servers.nix) into Zed's `context_servers`.
  programs.zed-editor.enableMcpIntegration = true;

  programs.zed-editor.userSettings =
    builtins.fromJSON (builtins.readFile ../zed/settings.json);
}
