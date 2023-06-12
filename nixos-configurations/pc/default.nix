{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  networking.hostName = "pc";

  home-manager.users.thiloho = { ... }: {
    wayland.windowManager.sway.config.output = {
      DP-1 = {
        bg = "/home/thiloho/background.jpg fill";
        res = "1920x1080@144.000Hz";
      };
      DP-2 = {
        bg = "/home/thiloho/background.jpg fill";
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

