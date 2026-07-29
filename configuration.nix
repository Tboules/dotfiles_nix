{...}: {
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "tony";
  users.users.tony = {
    home = "/Users/tony";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2; # fast key repeat
      InitialKeyRepeat = 15; # short delay before repeat
      _HIHideMenuBar = false;
      AppleShowAllExtensions = true;
      "com.apple.swipescrolldirection" = false;
    };
    dock.autohide = true;
    finder.FXPreferredViewStyle = "Nlsv"; # list view by default
    controlcenter = {
      Bluetooth = true;
      Sound = true;
    };
  };

  nix-homebrew = {
    enable = true;
    user = "tony";
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.extraFlags = ["--force"];
    brews = [
      "herdr"
    ];
    casks = [
      "ghostty"
      "claude-code"
      "spotify"
      "karabiner-elements"
      "obsidian"
    ];
  };
}
