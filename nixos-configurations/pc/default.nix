{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  networking.hostName = "pc";

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    wayland.windowManager.sway.config.output = let
      wallpaper = pkgs.fetchurl {
        url = "https://imgur.com/aAWzGqj.jpg";
        hash = "sha256-iTQS939Zrvjv4rBJ6Y41kdsBBN9lT5yAoJnNg/WiMoA=";
      };
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
  };
}

