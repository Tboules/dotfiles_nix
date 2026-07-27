{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles_nix";

{
  home.username = "tony";
  home.homeDirectory = "/home/tony";

  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    fzf
    ripgrep
    fd
    lazygit
    neovim
    nerd-fonts.jetbrains-mono
  ];
  font.fontconfig.enable = true;
  home.sessionVariables.EDITOR = "nvim";

  programs.home-manager.enable = true;

  # Edit-in-place: the real file stays in my dotfiles repo, but .config always points at it.
  home.file.".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/ghostty";
}

