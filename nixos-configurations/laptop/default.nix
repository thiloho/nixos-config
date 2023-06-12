{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  networking.hostName = "laptop";

  hardware.firmware = [ pkgs.broadcom-bt-firmware ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  home-manager.users.thiloho = { pkgs, ... }: {
    programs.git = {
      signing = {
        key = "86C465C22C8A4D56";
      };
    };
  };
}
