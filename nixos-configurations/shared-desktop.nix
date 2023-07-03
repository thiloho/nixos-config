{ ... }:

{
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    xserver = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
    gnome.core-utilities.enable = false;
  };
 
  # Home manager configuration
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
      helix = {
        enable = true;
        settings = {
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
      };
      alacritty = {
        enable = true;
        settings.font.size = 11.00;
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
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        EDITOR = "hx";
      };
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
        tofi
        wl-clipboard
        xdg-utils
        slurp
        grim
        swappy
        kooha
        ventoy
        tldr
      ];
    };
  };
}
