{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
    ./hardware-configuration.nix
    ../shared-desktop.nix
    ../shared.nix
  ];

  networking.hostName = "laptop";


  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  home-manager.users.thiloho = { pkgs, ... }: {
    programs.git.signing.key = "BFD8F6A55B1E4F11";
    home = { stateVersion = "23.05"; };
  };
  system.stateVersion = "23.05";
}
