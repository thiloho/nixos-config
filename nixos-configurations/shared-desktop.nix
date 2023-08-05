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
    steam.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };
  };

  hardware.pulseaudio.enable = false;

  home-manager.users.thiloho = { pkgs, lib, config, ... }: {
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
      firefox = {
        enable = true;
        package = pkgs.firefox-devedition;
      };
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
      git = {
        enable = true;
        userName = "thiloho";
        userEmail = "123883702+thiloho@users.noreply.github.com";
        signing = {
          signByDefault = true;
        };
      };
      obs-studio.enable = true;
    };
    home = {
      packages = with pkgs; [
        libreoffice
        airshipper
        tldr
        prismlauncher
        ventoy-full
        psensor
        spotify
      ];
    };
  };
}
