{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  networking.hostName = "pc";

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    wayland.windowManager.sway.config.output = let
      wallpaper = pkgs.callPackage ../wallpaper.nix {};
    in {
      DP-1 = {
        bg = "${wallpaper} fill";
        res = "1920x1080@144.000Hz";
      };
      DP-2 = {
        bg = "${wallpaper} fill";
        res = "1920x1080@144.000Hz";
      };
    };
    programs.git = {
      signing = {
        key = "74F3E176485BE7DA";
      };
    };
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}

