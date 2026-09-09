# dotfiles_nix

Declarative macOS (Apple Silicon) setup using `nix-darwin` + `home-manager` +
`nix-homebrew`, driven from a single flake.

## What this manages

- System defaults (`configuration.nix`): dark mode, key repeat rate, dock/finder prefs, etc.
- Homebrew, installed and managed *by Nix* (`nix-homebrew`): casks (ghostty, claude-code,
  spotify, karabiner-elements, obsidian, zen, raycast) and brews (`herdr`).
- User environment (`home.nix`): shell (zsh + starship + zoxide), CLI tools (ripgrep, fd,
  eza, lazygit, fzf, bat, btop, uv), language toolchains (rust, go, node, python, dotnet 10),
  Neovim, and fonts.
- Dotfiles for ghostty, nvim, herdr, and karabiner are symlinked out-of-store straight into
  this repo, so editing files under `home/.config/...` takes effect immediately (no rebuild
  needed for those files themselves — only `home.nix`/`configuration.nix` changes need a rebuild).

## Bootstrapping a new Mac

1. **Install Xcode Command Line Tools** (needed for `git`, compilers, etc.):

   ```sh
   xcode-select --install
   ```

2. **Install Nix.** This repo sets `nix.enable = false` in `configuration.nix`, which means
   nix-darwin expects Nix to already be installed and managed by an external installer
   (not by nix-darwin itself). Use the [Determinate Systems installer](https://determinate.systems/nix-installer/),
   which installs Nix with flakes enabled by default:

   ```sh
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

   Restart your terminal after it finishes.

3. **Set up GitHub access** if you don't already have an SSH key registered (this repo's
   remote is an SSH URL). Either add a key to your GitHub account, or clone over HTTPS instead
   in the next step.

4. **Clone this repo to `~/Documents/code/dotfiles_nix`.** The path matters: the `rb`/`hn`
   shell aliases defined in `home.nix` hardcode it.

   ```sh
   mkdir -p ~/Documents/code
   git clone git@github.com:Tboules/dotfiles_nix.git ~/Documents/code/dotfiles_nix
   # or: git clone https://github.com/Tboules/dotfiles_nix.git ~/Documents/code/dotfiles_nix
   ```

5. **First-time activation.** `darwin-rebuild` doesn't exist yet on a fresh machine, so bootstrap
   with `nix run` once:

   ```sh
   cd ~/Documents/code/dotfiles_nix
   ln -sfn "$PWD" ~/.dotfiles_nix
   sudo nix run nix-darwin -- switch --flake ~/.dotfiles_nix#mac
   ```

   This will: install/adopt Homebrew and its casks/brews, set system defaults, and activate
   the home-manager profile (shell config, symlinked dotfiles, packages). It can take a while
   the first time (fresh Homebrew casks, toolchains, etc.).

6. **Open a new terminal window** so the zsh config (aliases, starship, zoxide) loads. From
   now on, rebuild with the `rb` alias instead of the full command:

   ```sh
   rb   # == sudo darwin-rebuild switch --flake ~/.dotfiles_nix#mac
   ```

## Manual steps Nix can't do for you

- **Karabiner Elements** needs Input Monitor / Accessibility permissions granted manually in
  System Settings → Privacy & Security the first time it runs.
- **Neovim plugins**: on first launch, `vim.pack` will clone all plugins declared in
  `lua/plugins/*.lua` automatically (needs network access). LSP servers/tools are then
  installed automatically via `mason-tool-installer`.
- **herdr's vim navigation plugin** (`vim-herdr-navigation`, referenced in
  `home/.config/herdr/config.toml`) isn't declared in Nix and must be installed manually
  once herdr itself is installed:

  ```sh
  herdr plugin install paulbkim-dev/vim-herdr-navigation \
    --ref 53e318c772c4d3b7fbd904ac43bcf3e5b5d8b244 -y
  ```

- **Raycast's settings/extensions/snippets/hotkeys** can't be declared in Nix — Raycast
  stores them in encrypted SQLite files, not plain config files, and has no CLI for
  import/export. The only supported path is the GUI: **Raycast → Settings → Advanced →
  Export/Import Data**. Workflow for keeping this in the dotfiles repo:

  1. On your current machine: Settings → Advanced → Export Data, save the `.rayconfig`
     file into this repo (e.g. `home/raycast/backup.rayconfig`), and commit it.
  2. On a new machine, after `rb` installs the Raycast cask: open Raycast → Settings →
     Advanced → Import Data, and point it at that file.

  This isn't automatic — re-export and commit periodically if your Raycast setup changes.

## Day-to-day

- `rb` — rebuild and switch after editing `home.nix` or `configuration.nix`.
- `hn <label>` — open/create a herdr workspace laid out with neovim/shell/git/claude tabs.
- Editing anything under `home/.config/{ghostty,nvim,herdr,karabiner}` takes effect without
  a rebuild, since those paths are symlinked directly into the repo.
