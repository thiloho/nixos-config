{ config, pkgs, ... }:

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
    enableDefaultFonts = true;
    fonts = with pkgs; [
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
          svelte.svelte-vscode
          astro-build.astro-vscode
        ];
        userSettings = {
          editor.tabSize = 2;
        };
      };
      alacritty = {
        enable = true;
        settings = {
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
      google-chrome
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
