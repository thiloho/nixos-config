{ pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  virtualisation.docker.enable = true;

  home-manager.users.thiloho =
    { ... }:
    {
      programs = {
        bash = {
          enable = true;
          shellAliases = {
            rbs = "sudo nixos-rebuild switch --flake .";
            cleanup = "nix store optimise && nix-collect-garbage -d && sudo nix store optimise && sudo nix-collect-garbage -d";
          };
        };
        helix = {
          enable = true;
          defaultEditor = true;
          settings.theme = "ayu_dark";
        };
      };
    };
}
