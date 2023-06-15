{ ... }:

{
  imports = [
    ./hardware-configuration.nix
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
        key = "86C465C22C8A4D56";
      };
    };
  };
}
