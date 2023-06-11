{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Amsterdam";

  networking.networkmanager.enable = true;

  hardware.pulseaudio.enable = false;

  virtualisation.docker.enable = true;

  services = {
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

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      nerdfonts
      roboto
      jetbrains-mono
    ];
  };

  users.users.thiloho = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gtk2";
  };

  # Home manager configuration
  home-manager.users.thiloho = { pkgs, lib, ... }: {
    programs = {
      bash = {
        enable = true;
        shellAliases = {
          rbs = "sudo nixos-rebuild switch --flake .";
        };
      };
      helix = {
        enable = true;
        settings = {
          theme = "gruvbox_transparent";
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
        themes = {
          gruvbox_transparent = {
            "inherits" = "gruvbox";
            "ui.background" = "{}";
          };
        };
      };
      alacritty = {
        enable = true;
        settings = {
          window.opacity = 0.9;
          font = {
            normal = {
              family = "JetBrainsMono";
              style = "regular";
            };
            bold = {
              family = "JetBrainsMono";
              style = "regular";
            };
            italic = {
              family = "JetBrainsMono";
              style = "regular";
            };
            bold_italic = {
              family = "JetBrainsMono";
              style = "regular";
            };
            size = 11.00;
          };
        };
      };
      firefox.enable = true;
      chromium = {
        enable = true;
        extensions = [
          { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
          { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; }
          { id = "mmbiohbmijkiimgcgijfomelgpmdiigb"; }
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
      gh.enable = true;
    };
    home = {
    stateVersion = "22.11";
    packages = with pkgs; [
      zoom-us
      libreoffice
      airshipper
      prismlauncher
      nil
      rust-analyzer
      marksman
      nodePackages.typescript-language-server
      nodePackages.svelte-language-server
      nodePackages.vscode-langservers-extracted
    ];
  };
};

  system.stateVersion = "22.11";
}
