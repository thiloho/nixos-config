{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations = let
      mkSystem = entrypoint: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          entrypoint
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
        ];
      };
    in {
      pc = mkSystem ./nixos-configurations/pc;
      laptop = mkSystem ./nixos-configurations/laptop;
      server = mkSystem ./nixos-configurations/server;
    };
  };
}
