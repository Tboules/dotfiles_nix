{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/.dotfiles_nix";
  wallpaper = "${dotfiles}/wallpapers/wp1933958-pixel-art-wallpapers.jpg";
in {
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    zoxide
    eza
    fzf
    ripgrep
    fd
    jq
    lazygit
    neovim
    nerd-fonts.jetbrains-mono
    cargo
    rustc
    go
    nodejs
    python3
    dotnetCorePackages.sdk_10_0
    tree-sitter
    bat
    btop
    uv
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables.EDITOR = "nvim";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      cd = "z";
      ls = "eza --icons";
      ll = "eza -lg --icons";
      lt = "eza -lTag --level=2 --icons";
      rb = "~/Documents/code/dotfiles_nix/scripts/rebuild.sh";
      hn = "~/Documents/code/dotfiles_nix/scripts/herdr-session.sh";
      ".." = "cd ..";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; # since you're on zsh
  };

  programs.home-manager.enable = true;

  # Edit-in-place: the real file stays in my dotfiles repo, but .config always points at it.
  home.file.".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/ghostty";
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr/config.toml";
  home.file.".config/karabiner/karabiner.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/karabiner/karabiner.json";

  home.activation.setWallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD /usr/bin/osascript -e 'tell application "System Events" to tell every desktop to set picture to "${wallpaper}"' $VERBOSE_ARG
  '';
}
