{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Amsterdam";

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  hardware.pulseaudio.enable = false;

  virtualisation.docker.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  sound.enable = true;

  hardware.opengl.enable = true;

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };
  
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

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      nerdfonts
      roboto
      jetbrains-mono
    ];
  };

  users.users.thiloho = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gtk2";
  };

  # Home manager configuration
  home-manager.users.thiloho = { pkgs, lib, config, ... }: {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        modifier = "Mod1";
        terminal = "alacritty";
        menu = ''
          tofi-run --width "100%" --height "100%" --border-width 0 --outline-width 0 --padding-left "35%" --padding-top "35%" --result-spacing 25 --num-results 5 --font "monospace" --background-color "#000A" | xargs swaymsg exec --
        '';
        bars = [
          { command = "waybar"; }
        ];
        keybindings = let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+Shift+S" = ''exec grim -g "$(slurp)" - | swappy -f -'';
        };
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
            font-family: "JetBrains Mono";
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
      swaylock = {
        enable = true;
        settings = let
          wallpaper = pkgs.callPackage ./wallpaper.nix {};
        in {
          image = "${wallpaper}";
        };
      };
      bash = {
        enable = true;
        shellAliases = {
          rbs = "sudo nixos-rebuild switch --flake .";
          off = "sudo systemctl poweroff";
        };
      };
      helix = {
        enable = true;
        settings = {
          theme = "gruvbox_transparent";
          editor = {
            line-number = "relative";
            cursorline = true;
            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "underline";
            };
          };
          editor.file-picker = {
            hidden = false;
          };
        };
        themes = {
          gruvbox_transparent = {
            "inherits" = "gruvbox";
            "ui.background" = "{}";
          };
        };
      };
      alacritty = {
        enable = true;
        settings = {
          window.opacity = 0.75;
          font = {
            normal = {
              family = "JetBrainsMono";
              style = "regular";
            };
            bold = {
              family = "JetBrainsMono";
              style = "regular";
            };
            italic = {
              family = "JetBrainsMono";
              style = "regular";
            };
            bold_italic = {
              family = "JetBrainsMono";
              style = "regular";
            };
            size = 11.00;
          };
        };
      };
      firefox = {
        enable = true;
        package = pkgs.firefox-devedition;
      };
      git = {
        enable = true;
        userName = "thiloho";
        userEmail = "123883702+thiloho@users.noreply.github.com";
        signing = {
          signByDefault = true;
        };
      };
    };
    gtk = {
      enable = true;
      theme = {
        package = pkgs.gnome.gnome-themes-extra;
        name = "Adwaita-dark";
      };
    };
    home = {
      sessionVariables = {
        EDITOR = "hx";
      };
      stateVersion = "22.11";
      packages = with pkgs; [
        libreoffice
        airshipper
        prismlauncher
        nil
        rust-analyzer
        marksman
        nodePackages.typescript-language-server
        nodePackages.svelte-language-server
        nodePackages.vscode-langservers-extracted
        postgresqlJitPackages.plpgsql_check
        dconf
        tofi
        wl-clipboard
        xdg-utils
        slurp
        grim
        swappy
      ];
  };
};

  system.stateVersion = "22.11";
}
