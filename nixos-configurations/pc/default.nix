{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  networking.hostName = "pc";
  
  hardware.opengl.enable = true;

  security.polkit.enable = true;

  home-manager.users.thiloho = { pkgs, ... }: {
    wayland.windowManager.sway = {
      enable = true;
      config = {
        modifier = "Mod1";
        terminal = "alacritty";
        output = {
          DP-1 = {
            res = "1920x1080@144.000Hz";
          };
          DP-2 = {
            res = "1920x1080@144.000Hz";
          };
        };
      };
    };
    programs.git = {
      signing = {
        key = "29791D54E85BEE9E";
      };
    };
  };
}

