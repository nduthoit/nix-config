{ lib, ... }:

{
  # Ghostty is installed via Homebrew cask; configure it via home.file
  # Config reference: https://ghostty.org/docs/config
  home.file."Library/Application Support/com.mitchellh.ghostty/config".text = lib.generators.toKeyValue
    { mkKeyValue = lib.generators.mkKeyValueDefault {} " = "; }
    {
      # Font
      font-family = "JetBrainsMono Nerd Font Mono";
      font-size = 14;

      # Theme — switches automatically with macOS light/dark mode
      theme = "Github Dark High Contrast";

      # Window
      window-padding-x = 10;
      window-padding-y = 10;
      window-save-state = "always";
      background-opacity = "0.7";
      background-blur-radius = 15;

      # Behavior
      copy-on-select = "clipboard";
      scrollback-limit = 100000;

      # Shell
      shell-integration = "fish";
    } + lib.concatMapStrings (entry: "keybind = ${entry}\n") [
      "cmd+shift+r=new_split:right"
      "cmd+shift+d=new_split:down"
      "alt+backspace=text:\\x17"
    ];
}
