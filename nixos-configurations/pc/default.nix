{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  networking.hostName = "pc";
  
  hardware.opengl.enable = true;

  security.polkit.enable = true;
  
  # Make swaylock work
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };
  
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  home-manager.users.thiloho = { pkgs, ... }: {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        modifier = "Mod1";
        terminal = "alacritty";
        menu = "bemenu-run";
        output = {
          DP-1 = {
            res = "1920x1080@144.000Hz";
          };
          DP-2 = {
            res = "1920x1080@144.000Hz";
          };
        };
      };
      xwayland = false;
    };
    gtk = {
      enable = true;
      theme = {
        package = pkgs.gnome.gnome-themes-extra;
        name = "Adwaita-dark";
      };
    };
    programs = {
      git = {
        signing = {
          key = "C7F24D961CB819A5";
        };
      };
      swaylock.enable = true;
    };
    home.packages = with pkgs; [
      dconf
      bemenu
      wayshot
      wl-clipboard
      xdg-utils
      slurp
    ];
  };
}

