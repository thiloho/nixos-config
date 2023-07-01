{ pkgs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared-desktop.nix
    ../shared.nix
  ];

  networking.hostName = "laptop";
  
  hardware.firmware = [ pkgs.broadcom-bt-firmware ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  home-manager.users.thiloho = { pkgs, ... }: {
    wayland.windowManager.sway.config.output = let
      wallpaper = pkgs.callPackage ../wallpaper.nix {};
    in {
      eDP-1 = {
        bg = "${wallpaper} fill";
      };
    };
    programs.git = {
      signing = {
        key = "11BA77C2BDCEBF6A";
      };
    };
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}
