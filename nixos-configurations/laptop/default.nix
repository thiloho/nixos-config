{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  environment.variables = {
    TERMINAL = "alacritty";
  };

  networking.hostName = "laptop";

  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
    };
    libinput.enable = true;
    videoDrivers = [ "modesetting" "nvidia" ];
  };

  hardware = {
    bluetooth.enable = true;
    firmware = [ pkgs.broadcom-bt-firmware ];
  };

  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  home-manager.users.thiloho = { pkgs, ... }: {
    programs.git = {
      signing = {
        key = "86C465C22C8A4D56";
      };
    };
    home.packages = with pkgs; [
      arduino
    ];
  };
}
