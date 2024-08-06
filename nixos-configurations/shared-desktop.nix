{ pkgs, lib, ... }:

{
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome = {
        enable = true;
        # extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
        # fractional scaling support
        # extraGSettingsOverrides = ''
        #   [org.gnome.mutter]
        #   experimental-features=['scale-monitor-framebuffer']
        # '';
      };
      excludePackages = [ pkgs.xterm ];
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
    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      ensureDatabases = [ "dcbot" "todos" ];
      authentication = lib.mkForce ''
        local all all trust
        host all all 0.0.0.0/0 scram-sha-256
        host all all ::1/128 scram-sha-256
      '';
    };
  };

  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = "$y$j9T$BfX6ErL64B97Ug1ZrH1GN.$cK/3FlWSDJ99wpbbwu3hBAPX0jGew/zfJhQKf7/OQ12";
      thiloho = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "docker" ];
        hashedPassword = "$y$j9T$PmPi.Ji1jDw5rBaKCRepp/$LJLuvnFXiG/8jomOPVwv31R/tKgUmp.W2mKdo08FUK3";
      };
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
    };
    java.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        nodejs
        nodePackages.pnpm
      ];
    };
  };

  hardware.pulseaudio.enable = false;

  hardware.bluetooth.enable = true;

  home-manager.users.thiloho = { pkgs, lib, config, ... }: {
    programs = {
      yt-dlp = {
        enable = true;
      };
      firefox = {
        enable = true;
        package = pkgs.firefox-devedition.override {
          cfg = { speechSynthesisSupport = true; };
        };
      };
      chromium = {
        enable = true;
        package = pkgs.brave;
      };
      vscode = {
        enable = true;
        package = pkgs.vscodium;
        mutableExtensionsDir = false;
        extensions = with pkgs.vscode-extensions; [
          # svelte.svelte-vscode
          jnoortheen.nix-ide
          ritwickdey.liveserver
          esbenp.prettier-vscode
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "svelte-vscode";
            publisher = "svelte";
            version = "108.5.4";
            sha256 = "0sjq5ifnz08pkxslzz2qnrc76gvl6lkygcr3042safbvfral4xm1";
          }
        ];
        userSettings = {
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "editor.indentSize" = 2;
          "editor.tabSize" = 2;
          "typescript.preferences.importModuleSpecifier" = "relative";
          "[svelte]" = {
            "editor.defaultFormatter" = "svelte.svelte-vscode";
          };
          "svelte.enable-ts-plugin" = true;
          "svelte.plugin.svelte.defaultScriptLanguage" = "ts";
          "svelte.plugin.svelte.format.config.svelteStrictMode" = true;
        };
      };
      git = {
        enable = true;
        userName = "thiloho";
        userEmail = "123883702+thiloho@users.noreply.github.com";
        signing = { signByDefault = true; };
      };
      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
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
        qbittorrent
        neofetch
        godot_4
        backblaze-b2
        localsend
        mullvad-browser
        postman
        dbeaver-bin
        texliveFull
        gnome-tweaks
        gnome-themes-extra
        melonDS
        amberol
        zed-editor
      ];
    };
  };
}
