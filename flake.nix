{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    website = {
      url = "github:thiloho/website";
      flake = false;
    };
    aurora-blog-template = {
      url = "github:thiloho/aurora";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    denbot = {
      url = "github:thiloho/discord-bot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    todos = {
      url = "github:thiloho/todos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = let
      mkSystem = entrypoint: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          entrypoint
          { nix.registry.nixpkgs.flake = nixpkgs; }
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
