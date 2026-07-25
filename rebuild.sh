#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles_nix
exec sudo darwin-rebuild switch --flake ~/.dotfiles_nix#mac
