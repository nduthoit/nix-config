{ config, lib, ... }:

let
  inherit (lib) mkIf;
  caskPresent = cask: lib.any (x: x.name == cask) config.homebrew.casks;
  brewEnabled = config.homebrew.enable;
in

{
  environment.shellInit = mkIf brewEnabled ''
    eval "$(${config.homebrew.prefix}/bin/brew shellenv)"
  '';

  # https://docs.brew.sh/Shell-Completion#configuring-completions-in-fish
  # For some reason if the Fish completions are added at the end of `fish_complete_path` they don't
  # seem to work, but they do work if added at the start.
  programs.fish.interactiveShellInit = mkIf brewEnabled ''
    if test -d (brew --prefix)"/share/fish/completions"
      set -p fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
      set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
  '';

  homebrew.enable = true;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.global.brewfile = true;

  homebrew.taps = [
    "nrlquaker/createzap"
    "common-fate/granted"
    "pkgxdev/made"
  ];

  # Prefer installing application from the Mac App Store (they have to have been bought previously to work)
  # Uses https://github.com/mas-cli/mas#-usage (see that page for instructions on how to get the app ID)
  homebrew.masApps = {
    Amphetamine = 937984704;
    "Bee DICOM Viewer" = 1590273176;
    BlueMail = 1458754578;
    DaisyDisk = 411643860;
    "iFinance 5" = 1500241909;
    Keynote = 409183694;
    Kindle = 302584613;
    "Microsoft Remote Desktop" = 1295203466;
    MindNode = 1289197285;
    NordVPN = 905953485;
    Numbers = 409203825;
    Pages = 409201541;
    # Patterns = 429449079;
    "Be Focused - Pomodoro Timer" = 973134470;
    # "Pixelmator Pro" = 1289583905;
    # "Save to Raindrop.io" = 1549370672;
    Slack = 803453959;
    "Speedtest by Ookla" = 1153157709;
    "Tailscale" = 1475387142;
    Toggl = 1291898086;
    "Things 3" = 904280696;
    "WiFi Explorer" = 494803304;
    # Xcode = 497799835;
    # "Yubico Authenticator" = 1497506650;
  };

  # If an app isn't available in the Mac App Store, or the version in the App Store has
  # limitiations, e.g., Transmit, install the Homebrew Cask.
  homebrew.casks = [
    "1password"
    "1password-cli"
    "adobe-acrobat-reader"
    "alfred"
    "amazon-chime"
    "anytype"
    "calibre"
    "chatgpt"
    "db-browser-for-sqlite"
    "dbeaver-community"
    "divvy"
    "docker-desktop"
    "dropbox"
    "firefox"
    "ghostty"
    "google-chrome"
    "google-drive"
    # "gpg-suite"
    # "hammerspoon"
    "heynote"
    "iina"
    "iterm2"
    # "keybase"
    "kitty"
    "logseq"
    "microsoft-edge"
    "microsoft-office"
    "microsoft-teams"
    "mullvad-vpn"
    "obs"
    "obsidian"
    # "parallels"
    # "postman"
    # "raindropio"
    "signal"
    "spotify"
    # "superhuman"
    "visual-studio-code"
    # "vlc"
    "windows-app"
    "windsurf"
    # "yubico-yubikey-manager"
    # "yubico-yubikey-personalization-gui"
    "zoom"
  ];

  homebrew.brews = [
    "granted"
    "imagemagick"
    "mas"
    "pkgxdev/made/pkgx"
    "ollama"
  ];

  # Configuration related to casks
  home-manager.users.${config.users.primaryUser.username}.programs.ssh =
    mkIf (caskPresent "1password-cli" && config ? home-manager) {
      enable = true;
    };
}
