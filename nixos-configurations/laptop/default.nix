{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../shared.nix
    ];

    networking.hostName = "laptop";
}
