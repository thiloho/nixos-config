{ pkgs, ... }:

{
  home-manager.users.thiloho = { pkgs, lib, config, ... }: {
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
