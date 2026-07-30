# nix-config Workspace Rules

## Overview
Personal Nix configuration for macOS (Apple Silicon) managed with nix-darwin and home-manager.

- **User**: `nduthoit` (Nathan Duthoit)
- **Repo path**: `~/.config/nix-config`
- **Platform**: aarch64-darwin (Apple Silicon)
- **Shell**: Fish

## System Configurations
- `nathan-mbp23` — 2023 MacBook Pro (Apple Silicon)
- `nathan-mbp25` — 2025 MacBook Pro (Apple Silicon)

Both are built via `lib.mkDarwinSystem` in `flake.nix`.

## Key Commands
- `drs` — `darwin-rebuild switch --flake ~/.config/nix-config` (apply changes)
- `drb` — `darwin-rebuild build --flake ~/.config/nix-config` (dry run / smoke test)
- `flakeup` — update all flake inputs
- `nix flake lock --update-input <input>` — update a single input

## Repo Structure
```
flake.nix               # Entry point — inputs, overlays, system configs
flake.lock              # Locked input versions
darwin/                 # nix-darwin system modules (bootstrap, defaults, general, homebrew)
home/                   # home-manager modules (fish, git, packages, kitty, starship, etc.)
lib/                    # Helpers: mkDarwinSystem, lsnix
modules/                # Custom NixOS/HM modules (users.primaryUser, colors, kitty extras)
overlays/               # nixpkgs overlays (pkgs-master, pkgs-unstable, apple-silicon/x86)
work/                   # Work-specific overrides (git-ignored, optional)
```

## Conventions
- All darwin modules are in `darwin/`, imported via `darwinModules` in `flake.nix`.
- All home-manager modules are in `home/`, imported via `homeManagerModules` in `flake.nix`.
- Work-specific files live in `work/` and are loaded conditionally with `builtins.pathExists`.
- The `users.primaryUser` / `home.user-info` options are the single source of truth for username, email, and config directory.
- x86 package overrides go in the `apple-silicon` overlay in `flake.nix`.
- After any change, verify with `drb` before applying with `drs`.
