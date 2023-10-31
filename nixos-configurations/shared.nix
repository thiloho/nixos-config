{ inputs, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Amsterdam";

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  virtualisation.docker.enable = true;

  users.users.thiloho = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  home-manager.users.thiloho = { ... }: {
    programs = {
      bash = {
        enable = true;
        shellAliases = {
          rbs = "sudo nixos-rebuild switch --flake .";
          off = "sudo systemctl poweroff";
          cleanup = "nix store optimise && nix-collect-garbage -d && sudo nix store optimise && sudo nix-collect-garbage -d";
          listboots = "nix profile history --profile /nix/var/nix/profiles/system";
        };
      };
      helix = {
        enable = true;
        defaultEditor = true;
        settings.theme = "ayu_dark";
      };
    };
    home.packages = [ inputs.agenix.packages."x86_64-linux".default ];
  };
}
