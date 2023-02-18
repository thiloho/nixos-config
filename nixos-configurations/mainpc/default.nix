# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable experimental features nix-command and flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Allow proprietary software
  nixpkgs.config.allowUnfree = true;

  # Machine name for networking
  networking.hostName = "mainpc";

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Enable xorg
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    windowManager.i3 = {
      enable = true;
      extraSessionCommands = "xrandr --output DP-0 --left-of DP-4 --mode 1920x1080 --rate 144 --output DP-4 --mode 1920x1080 --rate 144";
    };
  };

  # Set default applications
  environment.variables = {
    TERMINAL = "alacritty";
  };

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; 
  };
 
  # Setting a user account
  users.users.thiloho = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # Use home manager as a module
  home-manager.users.thiloho = { pkgs, ... }: {
    programs = {
      firefox.enable = true;
      helix.enable = true;
      alacritty.enable = true;
      git = {
        enable = true;
        userName = "thiloho";
        userEmail = "123883702+thiloho@users.noreply.github.com";
      };
    };

    home = {
      packages = with pkgs; [
        tldr
      ];
      stateVersion = "22.11";
    };
  };

  # Stateful version
  system.stateVersion = "22.11";
}

