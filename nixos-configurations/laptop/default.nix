{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
    ./hardware-configuration.nix

    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/development.nix
    ../../modules/home.nix
    ../../modules/media.nix
  ];

  networking.hostName = "laptop";

  boot.initrd.luks.devices.cryptroot = {
    device = "/dev/disk/by-uuid/f1b5a08f-e515-4fba-b3f4-2a1091063cdc";
  };

  home-manager.users.thiloho = {
    programs.git.signing.key = "3B62137A89493F7D";
    home.stateVersion = "24.11";
  };

  system.stateVersion = "24.11";
}
