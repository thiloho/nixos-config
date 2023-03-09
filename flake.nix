{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    website.url = "github:thiloho/website";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, agenix, ... }: {
    nixosConfigurations = {
      mainpc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos-configurations/mainpc
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          agenix.nixosModules.default
        ];
        specialArgs = {
          inherit (self) inputs;
        };
      };
      mainserver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos-configurations/mainserver
          agenix.nixosModules.default
        ];
        specialArgs = {
          inherit (self) inputs;
        };
      };
    };
  };
}
