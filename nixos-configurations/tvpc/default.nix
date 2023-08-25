{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared-desktop.nix
    ../shared.nix
  ];

  networking.hostName = "tvpc";

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    programs.git.signing.key = "5ECD00BDC15A987E";
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}

