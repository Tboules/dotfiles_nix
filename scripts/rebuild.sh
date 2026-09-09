#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles_nix
USERNAME="$(id -un)"
exec sudo darwin-rebuild switch --flake "$HOME/.dotfiles_nix#${USERNAME}"
