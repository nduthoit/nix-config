# My Nix Configs

Personal Nix configuration for macOS (Apple Silicon) managed with
[nix-darwin](https://github.com/LnL7/nix-darwin) and
[home-manager](https://github.com/nix-community/home-manager).

## Bootstrapping a New Mac

### 1. Install Xcode Command Line Tools

```bash
xcode-select --install
```

### 2. Install Homebrew

Homebrew is needed because nix-darwin manages Homebrew packages but does not install
Homebrew itself.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 3. Install Nix

Use the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer),
which handles macOS quirks and enables flakes out of the box:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Open a new terminal after installation to pick up the Nix environment.

### 4. Clone this repo

```bash
git clone https://github.com/nduthoit/nix-config.git ~/.config/nix-config
cd ~/.config/nix-config
```

### 5. First-time nix-darwin activation

Run this once to bootstrap nix-darwin (it uses `nix run` since `darwin-rebuild` doesn't
exist yet; change the hostname to match your machine):

```bash
nix run nix-darwin -- switch --flake ~/.config/nix-config#nathan-mbp23
```

This will take a while on first run as it builds everything. It will also restart the
Dock and apply system defaults.

> **Note:** If you see an error about `/etc/nix/nix.conf` or `/etc/shells` already
> existing, back them up and retry:

```bash
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.backup
sudo mv /etc/shells /etc/shells.backup
```

### 6. Set Fish as your default shell

After activation, Fish will be in `/etc/shells`. Set it as default:

```bash
chsh -s /run/current-system/sw/bin/fish
```

### 7. After first activation

From this point forward use the `drs` alias defined in Fish:

```fish
drs   # darwin-rebuild switch --flake ~/.config/nix-config
drb   # darwin-rebuild build  --flake ~/.config/nix-config (dry run)
```

---

## Day-to-Day Usage

| Command | Description |
| ------- | ----------- |
| `drs` | Apply configuration changes |
| `drb` | Build without applying (smoke test) |
| `flakeup` | Update all flake inputs |
| `nix flake lock --update-input <input>` | Update a single flake input |

---

## Repo Structure

```text
flake.nix               # Entry point — inputs, overlays, system configs
flake.lock              # Locked input versions
default.nix             # flake-compat shim for legacy nix commands
darwin/
  bootstrap.nix         # Nix settings, shells, stateVersion
  defaults.nix          # macOS system defaults (dock, finder, trackpad, etc.)
  general.nix           # Fonts, keyboard mapping, networking, TouchID sudo
  homebrew.nix          # Homebrew taps, casks, brews, and MAS apps
home/
  colors.nix            # Solarized colorscheme definitions
  config-files.nix      # Misc dotfiles (~/.vimrc, ~/.stack/config.yaml, etc.)
  fish.nix              # Fish shell functions, aliases, and init
  gh-aliases.nix        # GitHub CLI aliases
  git-aliases.nix       # Git aliases
  git.nix               # Git config (delta, SSH signing via 1Password, gh CLI)
  kitty.nix             # Kitty terminal config with light/dark color switching
  packages.nix          # All nix-managed packages + SSH config + direnv/bat/etc.
  starship.nix          # Starship prompt settings
  starship-symbols.nix  # NerdFont symbols for Starship
lib/
  mkDarwinSystem.nix    # Helper to build a nix-darwin + home-manager system
  lsnix.nix             # Utility to list .nix files in a directory
modules/
  darwin/users.nix      # Adds users.primaryUser.{username,fullName,email,...} options
  home/colors/          # Home-manager module for defining named colorschemes
  home/programs/kitty/  # Kitty extras: light/dark colors, NerdFont symbol_map
overlays/
  vimUtils.nix          # Helper to build Vim plugins from flake inputs
```

---

## Highlights

   * **[Flakes](./flake.nix)** — all inputs pinned in `flake.lock`, easy to update with
     `flakeup` or `nix flake lock --update-input <name>`.

   * **[`lib.mkDarwinSystem`](./lib/mkDarwinSystem.nix)** — thin wrapper around
     `darwin.lib.darwinSystem` that wires up home-manager, sets `users.primaryUser`, and
     handles `home.stateVersion`.

   * **[`users-primaryUser`](./modules/darwin/users.nix)** — declare
     `username`, `fullName`, `email`, and `nixConfigDirectory` once; reference them
     everywhere via `config.users.primaryUser.*` (darwin) or `config.home.user-info.*`
     (home-manager).

   * **[`programs-kitty-extras`](./modules/home/programs/kitty/extras.nix)** — adds
     `programs.kitty.extras.colors` for light/dark switching (installs `term-light`,
     `term-dark`, `term-background` scripts) and `useSymbolsFromNerdFont` to use a NerdFont
     for symbols while keeping a clean primary font.

   * **Unified colorscheme** ([Solarized](https://ethanschoonover.com/solarized/)) across
     Kitty and Fish. Toggle with `tb` (alias for `toggle-background`).

   * **[Git config](./home/git.nix)** — SSH commit signing via 1Password, enhanced diffs
     with [`delta`](https://github.com/dandavison/delta), and a large set of
     [aliases](./home/git-aliases.nix).

   * **Apple Silicon support** — `pkgs-x86` overlay for packages that don't build on ARM;
     `extra-platforms` set in [`darwin/bootstrap.nix`](./darwin/bootstrap.nix).

   * **[`default.nix`](./default.nix)** — `flake-compat` shim so legacy `nix-build` /
     `nix-env` commands still work against this flake.
