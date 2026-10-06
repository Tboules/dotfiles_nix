#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles_nix
USERNAME="$(id -un)"
sudo darwin-rebuild switch --flake "$HOME/.dotfiles_nix#${USERNAME}"

# If brew just upgraded herdr, the still-running server is now stale: its
# binary is gone and macOS will deny it access to ~/Documents. Restart it (or
# tell the user to) — see scripts/herdr-restart.sh for the full story.
if command -v herdr >/dev/null && pgrep -x herdr >/dev/null; then
  cli_ver="$(herdr --version 2>/dev/null | awk '{print $2}')"
  srv_ver="$(herdr status server 2>/dev/null | awk -F': ' '/^version/{print $2}')"
  if [ -n "$cli_ver" ] && [ "$cli_ver" != "$srv_ver" ]; then
    echo
    echo "rebuild: herdr was upgraded ($srv_ver -> $cli_ver); the running server is stale."
    if "$DIR/scripts/herdr-restart.sh"; then :; else
      echo "rebuild: herdr server NOT restarted. From a plain Ghostty window run:"
      echo "         ~/.dotfiles_nix/scripts/herdr-restart.sh"
    fi
  fi
fi
