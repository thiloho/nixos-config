{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared-desktop.nix
    ../shared.nix
  ];

  networking.hostName = "laptop";

  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  home-manager.users.thiloho = { pkgs, ... }: {
    programs.git.signing.key = "E78D9CC2F9EFC890";
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}
