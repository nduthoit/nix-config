{ pkgs, ... }:

{
  # Networking
  networking.dns = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  # environment.systemPackages = with pkgs; [
  #   kitty
  #   terminal-notifier
  # ];
  programs.nix-index.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    recursive
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.droid-sans-mono
  ];

  # Keyboard
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = false; # make sure this isn't also active
    userKeyMapping = [
      {
        # Caps Lock -> Grave Accent / Tilde (`~`)
        HIDKeyboardModifierMappingSrc = 30064771129;
        HIDKeyboardModifierMappingDst = 30064771125;
      }
    ];
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;
}
