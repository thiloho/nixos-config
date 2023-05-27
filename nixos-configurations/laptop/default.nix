{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../shared.nix
    ];

    networking.hostName = "laptop";

    hardware = {
      bluetooth.enable = true;
      firmware = [ pkgs.broadcom-bt-firmware ];
    };

    services = {
      xserver.libinput.enable = true;
    };

    boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

    home-manager.users.thiloho = { pkgs, ... }: {
      programs.git = {
        signing = {
          key = "86C465C22C8A4D56";
        };
      };
    };
}
