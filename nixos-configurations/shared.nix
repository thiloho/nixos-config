{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Amsterdam";

  networking.networkmanager.enable = true;

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "modesetting" "nvidia" ];
      windowManager.i3 = {
        enable = true;
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  sound.enable = true;
  security.rtkit.enable = true;

  environment.variables = {
    TERMINAL = "alacritty";
  };

  fonts.fonts = with pkgs; [
    noto-fonts-cjk-sans
  ];

  users.users.thiloho = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # Home manager configuration
  home-manager.users.thiloho = { pkgs, ... }: {
    programs = {
      helix = {
        enable = true;
        settings = {
          theme = "dark_plus";
          editor = {
            line-number = "relative";
            cursorline = true;
            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "underline";
            };
          };
        };
      };
      alacritty.enable = true;
      firefox.enable = true;
      git = {
        enable = true;
        userName = "thiloho";
        userEmail = "123883702+thiloho@users.noreply.github.com";
        signing = {
          key = "/home/thiloho/.ssh/id_ed25519.pub";
          signByDefault = true;
        };
        extraConfig.gpg.format = "ssh";
      };
      gh.enable = true;
    };
    services.flameshot.enable = true;
    home = {
      stateVersion = "22.11";
      packages = with pkgs; [
        zoom-us
      ];
    };
  };

  system.stateVersion = "22.11";
}

