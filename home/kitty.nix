{ config, lib, pkgs, ... }:

{
  # Kitty terminal
  # https://sw.kovidgoyal.net/kitty/conf.html
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.kitty.enable
  programs.kitty.enable = true;

  # General config ----------------------------------------------------------------------------- {{{

  programs.kitty.settings = {
    # shell = "/run/current-system/sw/bin/fish --login --interactive";
    background_opacity = "0.8";
    # https://fsd.it/shop/fonts/pragmatapro/
    font_family = "PragmataPro Mono Liga";
    font_size = "14.0";
    # adjust_line_height = "140%";
    disable_ligatures = "cursor"; # disable ligatures when cursor is on them

    # Window layout
    hide_window_decorations = "titlebar-only";
    window_padding_width = "10";

    # Tab bar
    tab_bar_edge = "top";
    tab_bar_style = "powerline";
    tab_title_template = "Tab {index}: {title}";
    active_tab_font_style = "bold";
    inactive_tab_font_style = "normal";
    tab_activity_symbol = "";
    copy_on_select = "clipboard";

    scrollback_pager_history_size = "2000";
  };

  # Change the style of italic font variants
  programs.kitty.extraConfig = ''
    modify_font underline_position 2
  '';

  programs.kitty.extras.useSymbolsFromNerdFont = "JetBrainsMono Nerd Font";
  # }}}

  # Colors config ------------------------------------------------------------------------------ {{{
  programs.kitty.extras.colors = {
    enable = true;

    # Background dependent colors
    dark = config.colors.solarized-dark.pkgThemes.kitty;
    light = config.colors.solarized-light.pkgThemes.kitty;
  };

  programs.fish.functions.set-term-colors = {
    body = "term-background $term_background";
    onVariable = "term_background";
  };
  programs.fish.interactiveShellInit = ''
    # Set term colors based on value of `$term_backdround` when shell starts up.
    set-term-colors
  '';
  # }}}
}
# vim: foldmethod=marker
