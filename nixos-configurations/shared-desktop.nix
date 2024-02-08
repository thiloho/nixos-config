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
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };

  programs = {
    steam.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };
    java.enable = true;
  };

  hardware.pulseaudio.enable = false;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  home-manager.users.thiloho = { pkgs, lib, config, ... }: {
    programs = {
      firefox = {
        enable = true;
        package =
          pkgs.firefox.override { cfg = { speechSynthesisSupport = true; }; };
      };
      chromium = {
        enable = true;
        package = pkgs.brave;
      };
      vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
          svelte.svelte-vscode
          jnoortheen.nix-ide
          ritwickdey.liveserver
          astro-build.astro-vscode
          dbaeumer.vscode-eslint
          bradlc.vscode-tailwindcss
          esbenp.prettier-vscode
        ];
        userSettings = {
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "window.titleBarStyle" = "custom";
          "editor.indentSize" = 2;
          "editor.tabSize" = 2;
        };
      };
      git = {
        enable = true;
        userName = "thiloho";
        userEmail = "123883702+thiloho@users.noreply.github.com";
        signing = { signByDefault = true; };
      };
      obs-studio.enable = true;
    };
    home = {
      sessionVariables = { NIXOS_OZONE_WL = 1; };
      packages = with pkgs; [
        libreoffice
        airshipper
        tldr
        prismlauncher
        ventoy-full
        psensor
        nil
        zoom-us
        teamspeak5_client
        discord
        qbittorrent
        neofetch
        godot_4
        backblaze-b2
        localsend
        mullvad-browser
      ];
    };
  };
}
