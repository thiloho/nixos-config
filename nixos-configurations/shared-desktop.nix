{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    printing.enable = true;
    resolved.enable = true;
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    dconf.enable = true;
  };

  hardware = {
    bluetooth.enable = true;  
    pulseaudio.enable = false;
  };

  # Home manager configuration
  home-manager.users.thiloho = { pkgs, lib, config, ... }: {
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
    dconf.settings = let
      wallpaper = pkgs.callPackage ./wallpaper.nix {};
    in {
      "org/gnome/desktop/background" = {
        picture-uri = "${wallpaper}";
        picture-uri-dark = "${wallpaper}";
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-schedule-automatic = false;
        night-light-schedule-from = 0.0;
        night-light-schedule-to = 0.0;
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
      };
    };
    programs = {
      bash = {
        enable = true;
        shellAliases = {
          rbs = "sudo nixos-rebuild switch --flake .";
          off = "sudo systemctl poweroff";
          cleanup = "nix store optimise && nix-collect-garbage -d && sudo nix store optimise && sudo nix-collect-garbage -d";
          listboots = "nix profile history --profile /nix/var/nix/profiles/system";
        };
      };
      firefox.enable = true;
      vscode = {
        enable = true;
        extensions = with pkgs; [
          vscode-extensions.svelte.svelte-vscode
          vscode-extensions.jnoortheen.nix-ide
          vscode-extensions.ritwickdey.liveserver
        ];
        userSettings = {
          "editor.tabSize" = 2;
        };
      };
      helix = {
        enable = true;
        defaultEditor = true;
        settings.theme = "ayu_dark";
      };
      git = {
        enable = true;
        userName = "thiloho";
        userEmail = "123883702+thiloho@users.noreply.github.com";
        # signing = {
          # signByDefault = true;
        # };
      };
    };
    home = {
      packages = with pkgs; [
        libreoffice
        airshipper
        tldr
        prismlauncher
        ventoy-full
      ];
    };
  };
}
