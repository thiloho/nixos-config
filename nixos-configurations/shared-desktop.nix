{ pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.pulseaudio.enable = false;

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    gnome.core-utilities.enable = false;
  };

  programs.dconf.enable = true;

  home-manager.users.thiloho = { pkgs, lib, config, ... }: {
    dconf.settings = let
      wallpaper = pkgs.callPackage ./wallpaper.nix {};
    in {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/background" = {
        picture-uri = "${wallpaper}";
        picture-uri-dark = "${wallpaper}";
      };
    };
    gtk = {
      enable = true;
      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };
    programs = {
      bash = {
        enable = true;
        shellAliases = {
          cleanup = "nix store optimise && nix-collect-garbage -d && sudo nix store optimise && sudo nix-collect-garbage -d";
          listboots = "nix profile history --profile /nix/var/nix/profiles/system";
        };
      };
      alacritty = {
        enable = true;
        settings = {
          window.opacity = 0.75;
          font.size = 11.00;
        };
      };
      firefox.enable = true;
      chromium = {
        enable = true;
        extensions = [
          { id = "mmbiohbmijkiimgcgijfomelgpmdiigb"; }
          { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; }
          { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
        ];
      };
      vscode.enable = true;
      git = {
        enable = true;
        userName = "thiloho";
        userEmail = "123883702+thiloho@users.noreply.github.com";
        signing = {
          signByDefault = true;
        };
      };
    };
    home = {
      packages = with pkgs; [
        libreoffice
        airshipper
        prismlauncher
        ventoy
        tldr
        steam
      ];
    };
  };
}
