{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  networking.hostName = "laptop";

  home-manager.users.thiloho = { pkgs, ... }: {
    wayland.windowManager.sway.config.output = let
      wallpaper = pkgs.fetchurl {
        url = "https://imgur.com/aAWzGqj.jpg";
        hash = "sha256-iTQS939Zrvjv4rBJ6Y41kdsBBN9lT5yAoJnNg/WiMoA=";
      };
    in {
      eDP-1 = {
        bg = "${wallpaper} fill";
      };
    };
    programs.git = {
      signing = {
        key = "86C465C22C8A4D56";
      };
    };
  };
}
