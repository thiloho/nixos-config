{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
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
    programs.git.signing.key = "5CF074CA31DD6686";
    home = { stateVersion = "23.05"; };
  };
  system.stateVersion = "23.05";
}
