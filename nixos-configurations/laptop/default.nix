{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared-desktop.nix
    ../shared.nix
  ];

  networking.hostName = "laptop";

  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    ensureDatabases = [ "dcbot" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser auth-method
      local all      all    trust
    '';
  };

  home-manager.users.thiloho = { pkgs, ... }: {
    programs.git.signing.key = "E78D9CC2F9EFC890";
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}
