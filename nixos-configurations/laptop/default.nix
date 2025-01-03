{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
    ./hardware-configuration.nix
    ../shared-desktop.nix
    ../shared.nix
  ];

  networking.hostName = "laptop";

  boot.initrd = {
    luks.devices = {
      cryptroot = {
        device = "/dev/disk/by-uuid/82ba475d-faa1-488f-82c4-77c1b7bb48da";
      };
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  home-manager.users.thiloho =
    { pkgs, ... }:
    {
      programs.git.signing.key = "3B62137A89493F7D";
      home = {
        stateVersion = "23.05";
      };
    };
  system.stateVersion = "23.05";
}
