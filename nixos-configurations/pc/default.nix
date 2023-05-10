{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../shared.nix
    ];

    services.xserver.windowManager.i3.extraSessionCommands = "xrandr --output DP-0 --left-of DP-4 --mode 1920x1080 --rate 144 --output DP-4 --mode 1920x1080 --rate 144";

    networking.hostName = "pc";
}

