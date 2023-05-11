{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../shared.nix
    ];

    networking.hostName = "laptop";

    services.xserver.libinput.enable = true;

    boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
}
