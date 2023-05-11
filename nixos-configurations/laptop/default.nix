{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../shared.nix
    ];

    networking = {
      hostName = "laptop";
      networkmanager.enable = true;
    };

    services.xserver.libinput.enable = true;
}
