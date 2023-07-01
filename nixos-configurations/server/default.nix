{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  networking.hostName = "server";

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}

