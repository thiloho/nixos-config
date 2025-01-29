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

    programs.helix = {
      enable = true;
      settings.theme = "ayu_dark";
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
      backblaze-b2
      localsend
      postman
      melonDS
      prismlauncher
      papers
      endeavour
      gapless
      mullvad-browser
      picocrypt-cli
      tutanota-desktop
      inkscape
      discord
    ];
  };
}
