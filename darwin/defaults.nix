{ config, ... }:

let
  username = config.users.primaryUser.username;
in

{
  system.primaryUser = username;
  system.defaults.NSGlobalDomain = {
    "com.apple.trackpad.scaling" = 1.0;
    AppleInterfaceStyleSwitchesAutomatically = true;
    AppleMeasurementUnits = "Centimeters";
    AppleMetricUnits = 1;
    AppleShowScrollBars = "Automatic";
    AppleTemperatureUnit = "Celsius";
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    _HIHideMenuBar = false;
  };

  # Firewall
  networking.applicationFirewall.enable = true;
  networking.applicationFirewall.allowSigned = true;
  networking.applicationFirewall.allowSignedApp = true;
  networking.applicationFirewall.enableStealthMode = true;

  # Dock and Mission Control
  system.defaults.dock = {
    autohide = true;
    expose-group-apps = false;
    mru-spaces = false;
    static-only = false;
    tilesize = 64;
    # Disable all hot corners
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
    persistent-others = [
      "/Users/${username}/Library/Mobile Documents/com~apple~CloudDocs/"
      { folder = { path = "/Users/${username}/Downloads"; arrangement = "date-added"; showas = "fan"; }; }
    ];
  };

  # Login and lock screen
  system.defaults.loginwindow = {
    GuestEnabled = false;
    DisableConsoleAccess = true;
  };

  # Spaces
  system.defaults.spaces.spans-displays = false;

  # Trackpad
  system.defaults.trackpad = {
    Clicking = true;
    TrackpadRightClick = true;
  };

  # Finder
  system.defaults.finder = {
    AppleShowAllFiles = true;
    FXEnableExtensionChangeWarning = true;
    ShowStatusBar = true;
    ShowPathbar = true;
  };
}
