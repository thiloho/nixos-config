{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared-desktop.nix
    ../shared.nix
  ];

  networking.hostName = "pc";

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    programs.git.signing.key = "1617CEF3B3EE7083";
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}

