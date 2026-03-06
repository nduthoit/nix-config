{ config, lib, ... }:

let
  dark = config.colors.solarized-dark;
  # colors and terminal values are already resolved to hex strings by the color module
  c = dark.colors;
  t = dark.terminal;
in

{
  # Ghostty is installed via Homebrew cask; configure it via home.file
  # Config reference: https://ghostty.org/docs/config
  home.file.".config/ghostty/config".text = lib.generators.toKeyValue
    { mkKeyValue = lib.generators.mkKeyValueDefault {} " = "; }
    {
      # Font
      font-family = "PragmataPro Mono Liga";
      font-size = 14;

      # Window
      window-padding-x = 10;
      window-padding-y = 10;
      window-save-state = "always";

      # Behavior
      copy-on-select = "clipboard";
      scrollback-limit = 100000;

      # Shell
      shell-integration = "fish";

      # Solarized dark colors
      background           = t.bg;
      foreground           = t.fg;
      cursor-color         = t.cursorBg;
      cursor-text          = t.cursorFg;
      selection-background = t.selectionBg;
      selection-foreground = t.selectionFg;
    } + "\n" + lib.concatMapStrings (entry: "palette = ${entry}\n") [
      "0=${c.color0}"
      "1=${c.color1}"
      "2=${c.color2}"
      "3=${c.color3}"
      "4=${c.color4}"
      "5=${c.color5}"
      "6=${c.color6}"
      "7=${c.color7}"
      "8=${c.color8}"
      "9=${c.color9}"
      "10=${c.color10}"
      "11=${c.color11}"
      "12=${c.color12}"
      "13=${c.color13}"
      "14=${c.color14}"
      "15=${c.color15}"
    ];
}
