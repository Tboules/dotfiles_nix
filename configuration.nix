{...}

{
	nix.enable = false;
	nixpkgs.config.allowUnfree = true;
	nixpkgs.hostPlatform = "aarch64-darwin";

	system.primaryUser = "tony";
	system.stateVersion = 6;
}
