{
  description = "Tony's darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    nix-homebrew,
  }: let
    mkDarwinConfig = username:
      nix-darwin.lib.darwinSystem {
        specialArgs = {inherit username;};
        modules = [
          ./configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = ./home.nix;
            home-manager.extraSpecialArgs = {inherit username;};
          }
        ];
      };
  in {
    darwinConfigurations = {
      tony = mkDarwinConfig "tony";
      tonyboules = mkDarwinConfig "tonyboules";
    };
  };
}
