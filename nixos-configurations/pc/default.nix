{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared-desktop.nix
    ../shared.nix
  ];

  networking.hostName = "pc";

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    # programs.git = {
    #   signing = {
    #     key = "A6C6D25B9687377B";
    #   };
    # };
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}

