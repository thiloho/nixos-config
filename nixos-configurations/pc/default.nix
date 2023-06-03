{ config, pkgs, ... }:

{
  imports = [
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
    wayland.windowManager.sway = {
      enable = true;
      config = {
        modifier = "Mod1";
        terminal = "alacritty";
      };
      extraConfig = ''
        output DP-1 mode 1920x1080@144.000Hz
        output DP-2 mode 1920x1080@144.000Hz
      '';
    };
    programs.git = {
      signing = {
        key = "29791D54E85BEE9E";
      };
    };
  };
}

