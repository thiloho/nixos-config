{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "itachi";

  time.timeZone = "Europe/Amsterdam";

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      windowManager.i3 = {
        enable = true;
        extraSessionCommands = "xrandr --output DP-0 --left-of DP-4 --mode 1920x1080 --rate 144 --output DP-4 --mode 1920x1080 --rate 144";
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
    extraGroups = [ "wheel" ];
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
      vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
          astro-build.astro-vscode
          bbenoist.nix
          ritwickdey.liveserver
          svelte.svelte-vscode
        ];
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
    };
    services.flameshot.enable = true;
    home = {
      stateVersion = "22.11";
    };
  };

  system.stateVersion = "22.11";
}

