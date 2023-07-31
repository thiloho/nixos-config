{ lib, pkgs, config, modulesPath, ... }:

{
  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "thiloho";
    startMenuLaunchers = true;
    nativeSystemd = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };

  networking.hostName = "ThilosPC";

  users.users.thiloho.isNormalUser = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };
  
  home-manager.users.thiloho = { pkgs, lib, config, ... }: {
    programs = {
      helix = {
        enable = true;
        defaultEditor = true;
        settings.theme = "ayu_dark";
      };
      git = {
        enable = true;
        userName = "thiloho";
        userEmail = "123883702+thiloho@users.noreply.github.com";
        signing = {
          signByDefault = true;
          key = "68E9DB8C7055C97A";
        };
      };
    };
    home = {
      stateVersion = "23.05";
      packages = with pkgs; [ wget ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.stateVersion = "23.05";
}
