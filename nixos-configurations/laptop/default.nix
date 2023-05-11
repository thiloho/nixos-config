{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../shared.nix
    ];

    networking.hostName = "laptop";

    services.xserver.libinput.enable = true;
}
