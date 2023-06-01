{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../shared.nix
    ];

    services.xserver.windowManager.i3.extraSessionCommands = "xrandr --output DP-1 --left-of DP-2 --mode 1920x1080 --rate 144 --output DP-2 --mode 1920x1080 --rate 144";

    networking.hostName = "pc";

    home-manager.users.thiloho = { pkgs, ... }: {
      programs.git = {
        signing = {
          key = "29791D54E85BEE9E";
        };
      };
    };
}

