{ pkgs, lib, ... }:

{
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
        # fractional scaling support
        extraGSettingsOverrides = ''
          [org.gnome.mutter]
          experimental-features=['scale-monitor-framebuffer']
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
      ensureDatabases = [ "dcbot" "todos" ];
      authentication = lib.mkForce ''
        local all all trust
        host all all 0.0.0.0/0 scram-sha-256
        host all all ::1/128 scram-sha-256
      '';
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
          svelte.svelte-vscode
          jnoortheen.nix-ide
          ritwickdey.liveserver
          astro-build.astro-vscode
          dbaeumer.vscode-eslint
          bradlc.vscode-tailwindcss
          esbenp.prettier-vscode
          pkief.material-icon-theme
          unifiedjs.vscode-mdx
          rust-lang.rust-analyzer
          tamasfe.even-better-toml
          mkhl.direnv
          james-yu.latex-workshop
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "biome";
            publisher = "biomejs";
            version = "2024.3.70509";
            sha256 = "1v17wb0b789c08kb5idm32jbi404xr90x7xlbcy7zgy3q2z1xpdj";
          }
        ];
        userSettings = {
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "editor.indentSize" = 2;
          "editor.tabSize" = 2;
          "typescript.preferences.importModuleSpecifier" = "relative";
          "workbench.iconTheme" = "material-icon-theme";
          "biome.lspBin" = "./node_modules/@biomejs/biome";
          "svelte.enable-ts-plugin" = true;
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
        teamspeak5_client
        qbittorrent
        neofetch
        godot_4
        backblaze-b2
        localsend
        mullvad-browser
        insomnia
        dbeaver-bin
        texliveFull
        gnome.gnome-tweaks
        gnome.gnome-themes-extra
        melonDS
      ];
    };
  };
}
