{ pkgs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared-desktop.nix
    ../shared.nix
  ];

  networking.hostName = "laptop";

  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  home-manager.users.thiloho = { pkgs, ... }: {
    # programs.git = {
      # signing = {
        # key = "11BA77C2BDCEBF6A";
      # };
    # };
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}
