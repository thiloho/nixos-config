{ pkgs, lib, ... }:

{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  fonts.packages = with pkgs; [
    jetbrains-mono
  ];

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverridePackages = [ pkgs.mutter ];
        # fractional scaling support
        extraGSettingsOverrides = ''
          [org.gnome.mutter]
          experimental-features=['scale-monitor-framebuffer', 'variable-refresh-rate']
        '';
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
      authentication = lib.mkForce ''
        local all all trust
        host all all 0.0.0.0/0 scram-sha-256
        host all all ::1/128 scram-sha-256
      '';
    };
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-connections
    geary
    evince
    gnome-calendar
    gnome-contacts
    gnome-weather
    gnome-maps
    gnome-clocks
    gnome-music
    snapshot
    simple-scan
  ];

  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = "$y$j9T$gdQiD91dRc1rEURkntnkh1$9VvI8xhvCMqhSSOeOkiSnjHsQVUOOH/4Sbou.w6P5TC";
      thiloho = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "docker"
        ];
        hashedPassword = "$y$j9T$0wgXXBJMy5lzuwmdvx5Lb.$G5JmfDXeXzH7sq66R.clvmlovuh1ZsZMf1SfDsWpNcB";
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

  home-manager.users.thiloho =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs = {
        yt-dlp = {
          enable = true;
        };
        firefox = {
          enable = true;
          package = pkgs.firefox-devedition.override {
            cfg = {
              speechSynthesisSupport = true;
            };
          };
        };
        chromium = {
          enable = true;
          package = pkgs.ungoogled-chromium;
        };
        vscode = {
          enable = true;
          package = pkgs.vscodium;
          mutableExtensionsDir = false;
          extensions =
            with pkgs.vscode-extensions;
            [
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
              {
                name = "playwright";
                publisher = "ms-playwright";
                version = "1.1.10";
                sha256 = "0y0jlrxpjzd7drdmcr9kfy5g12zax9q4d8cblzzb6ia4c98ipfq0";
              }
            ];
          userSettings = {
            "editor.wordWrap" = "on";
            "editor.fontFamily" = "JetBrains Mono";
            "editor.fontLigatures" = true;
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
          signing = {
            signByDefault = true;
          };
        };
        direnv = {
          enable = true;
          enableBashIntegration = true;
          nix-direnv.enable = true;
        };
        obs-studio.enable = true;
      };
      home = {
        packages = with pkgs; [
          tldr
          ventoy-full
          qbittorrent
          neofetch
          backblaze-b2
          localsend
          postman
          gnome-tweaks
          gnome-themes-extra
          melonDS
          prismlauncher
          papers
          endeavour
          gapless
          mullvad-browser
          picocrypt-cli
        ];
      };
    };
}
