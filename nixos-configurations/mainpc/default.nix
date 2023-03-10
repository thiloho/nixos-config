{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared.nix
    ];

  # Machine name for networking
  networking.hostName = "mainpc";

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

  age.secrets = {
    mainpc-root-password.file = ../../secrets/mainpc-root-password.age;
    mainpc-thiloho-password.file = ../../secrets/mainpc-thiloho-password.age;
  };

  users.users.root.passwordFile = config.age.secrets.mainpc-root-password.path;    
  users.users.thiloho.passwordFile = config.age.secrets.mainpc-thiloho-password.path;

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
        flameshot
        # postgresql_15
      ];
      stateVersion = "22.11";
    };
  };

  # Stateful version
  system.stateVersion = "22.11";
}

