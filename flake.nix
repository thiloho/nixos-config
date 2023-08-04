{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    website = {
      url = "github:thiloho/website";
      flake = false;
    };
    aurora-blog-template.url = "github:thiloho/aurora";
    # NixOS-WSL = {
      # url = "github:nix-community/NixOS-WSL";
      # inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs@{ nixpkgs, home-manager, NixOS-WSL, ... }: {
    nixosConfigurations = let
      mkSystem = entrypoint: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          { nix = {
              nixPath = [ "nixpkgs=${nixpkgs}" ];
            };
          }
          entrypoint
          # NixOS-WSL.nixosModules.wsl
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
      # wsl = mkSystem ./nixos-configurations/wsl;
    };
  };
}
