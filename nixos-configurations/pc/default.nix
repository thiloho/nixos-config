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
        menu = ''
          tofi-run --width "100%" --height "100%" --border-width 0 --outline-width 0 --padding-left "35%" --padding-top "35%" --result-spacing 25 --num-results 5 --font "monospace" --background-color "#000A" | xargs swaymsg exec --
        '';
        output = {
          DP-1 = {
            bg = "/home/thiloho/background.jpg fill";
            res = "1920x1080@144.000Hz";
          };
          DP-2 = {
            bg = "/home/thiloho/background.jpg fill";
            res = "1920x1080@144.000Hz";
          };
        };
        bars = [
          { command = "waybar"; }
        ];
      };
      xwayland = false;
    };
    programs = {
      waybar = {
        enable = true;
        settings = [
          {
            modules-left = [ "sway/workspaces" ];
            modules-center = [ "sway/window" ];
            modules-right = [ "user" "memory" "disk" "cpu" "clock" ];  

            user = {
              format = "{user} - Uptime: {work_H}:{work_M}h";
            };

            memory = {
              format = "Memory: {used}GiB";
            };

            disk = {
              format = "Disk: {free}";
            };

            cpu = {
              format = "CPU: {usage}%";
            };

            clock = {
              interval = 60;
              format = "{:%Y-%m-%d - %H:%M}";
            };
          }
        ];
        style = ''
          * {
            font-size: 0.875rem;
            border: none;
            border-radius: 0;
          }
        
          window#waybar {
            background-color: #1a1a1a;
            color: #e6e6e6;
          }

          #workspaces button, #user, #memory, #disk, #cpu, #clock {
            padding-top: 0.125rem;
            padding-bottom: 0.125rem;
            padding-left: 0.5rem;
            padding-right: 0.5rem;
            background-color: #262626;
            border: 0.0625rem solid #404040;
          }
        '';
      };
      git = {
        signing = {
          key = "8A14DB4580E6248C";
        };
      };
      swaylock.enable = true;
    };
    gtk = {
      enable = true;
      theme = {
        package = pkgs.gnome.gnome-themes-extra;
        name = "Adwaita-dark";
      };
    };
    home = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      packages = with pkgs; [
        dconf
        tofi
        wayshot
        wl-clipboard
        xdg-utils
        slurp
      ];
    };
  };
}

