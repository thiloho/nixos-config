{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../shared.nix
    ];

    networking.hostName = "pc";

    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
    };

    programs.sway.enable = true;

    home-manager.users.thiloho = { pkgs, ... }: {
      programs.git = {
        signing = {
          key = "29791D54E85BEE9E";
        };
      };
    };
}

