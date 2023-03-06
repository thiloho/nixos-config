{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    website.url = "github:thiloho/thiloho.github.io";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
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
        ];
      };
      mainserver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos-configurations/mainserver
        ];
      };
      virtualserver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos-configurations/virtualserver
        ];
        specialArgs = {
          inherit (self) inputs;
        };
      };
    };
  };
}
