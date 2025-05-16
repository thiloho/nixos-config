{ pkgs, ... }:
{
  home-manager.users.thiloho = {
    programs.bash = {
      enable = true;
      shellAliases = {
        rbs = "sudo nixos-rebuild switch --flake .";
        cleanup = "nix store optimise && nix-collect-garbage -d && sudo nix store optimise && sudo nix-collect-garbage -d";
      };
    };

    programs = {
      git = {
        enable = true;
        userName = "thiloho";
        userEmail = "123883702+thiloho@users.noreply.github.com";
        signing = {
          signByDefault = true;
        };
      };

      vscode = {
        enable = true;
        package = pkgs.vscodium;
        mutableExtensionsDir = false;
        extensions =
          with pkgs.vscode-extensions;
          [
            jnoortheen.nix-ide
            ritwickdey.liveserver
            esbenp.prettier-vscode
            astro-build.astro-vscode
            svelte.svelte-vscode
          ];
        userSettings = {
          "editor.wordWrap" = "on";
          "editor.fontFamily" = "JetBrains Mono";
          "editor.fontLigatures" = true;
          "editor.indentSize" = 2;
          "editor.tabSize" = 2;
          "typescript.preferences.importModuleSpecifier" = "relative";
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[svelte]" = {
            "editor.defaultFormatter" = "svelte.svelte-vscode";
          };
          "svelte.enable-ts-plugin" = true;
          "svelte.plugin.svelte.defaultScriptLanguage" = "ts";
          "svelte.plugin.svelte.format.config.svelteStrictMode" = true;
        };
      };

      firefox = {
        enable = true;
        package = pkgs.firefox-devedition.override {
          cfg = {
            speechSynthesisSupport = true;
          };
        };
      };

      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };

      yt-dlp.enable = true;

      obs-studio.enable = true;
    };

    home.packages = with pkgs; [
      tldr
      ventoy-full
      qbittorrent
      neofetch
      localsend
      postman
      prismlauncher
      papers
      endeavour
      gapless
      mullvad-browser
      picocrypt-cli
      tutanota-desktop
      inkscape
      discord
      onlyoffice-desktopeditors
    ];
  };
}
