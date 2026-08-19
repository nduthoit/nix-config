{ config, lib, pkgs, ... }:

let
  # Claude Code stores user-scope MCP servers under the top-level `mcpServers`
  # key of ~/.claude.json. Claude owns that file (chat history, per-project
  # state), so merge our entries in rather than generating it.
  claudeConfig = "${config.home.homeDirectory}/.claude.json";

  serversJSON = builtins.toJSON config.programs.mcp.servers;
in

{
  # Shared MCP server set. Home Manager writes it to `~/.config/mcp/mcp.json`, and
  # `programs.zed-editor.enableMcpIntegration` (see ./zed.nix) folds it into Zed's
  # `context_servers`.
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mcp.enable
  programs.mcp.enable = true;

  programs.mcp.servers = {
    # Official git MCP server from modelcontextprotocol/servers.
    # Referenced by absolute store path so GUI-launched clients work without the
    # nix profile on their PATH. No `--repository` flag: every tool takes a
    # `repo_path` argument, so one instance serves all repos.
    git = {
      command = lib.getExe pkgs.mcp-server-git;
      args = [ ];
    };
  };

  # Home Manager's `programs.claude-code` module can't be used here: it wires MCP by
  # wrapping a nix-installed `claude-code` package, but Claude Code comes from the
  # Homebrew cask. Merge the servers into its config with `jq` instead.
  home.activation.registerClaudeMCPServers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    _config="${claudeConfig}"

    if [ -n "$DRY_RUN_CMD" ]; then
      echo "mcp: would merge MCP servers into $_config"
    else
      _tmp="$_config.nix-tmp"

      if [ ! -e "$_config" ]; then
        install -m 600 /dev/null "$_config"
        echo '{}' > "$_config"
      fi

      # Nix-declared servers win on a name collision; servers added by hand under
      # other names are preserved.
      if ${lib.getExe pkgs.jq} --argjson servers ${lib.escapeShellArg serversJSON} \
           '.mcpServers = ((.mcpServers // {}) + $servers)' "$_config" > "$_tmp"; then
        mv "$_tmp" "$_config"
        chmod 600 "$_config"
        echo "mcp: registered MCP servers in $_config"
      else
        rm -f "$_tmp"
        echo "mcp: could not update $_config -- is it valid JSON?" >&2
      fi
    fi
  '';
}
