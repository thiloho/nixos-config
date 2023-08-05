{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared-desktop.nix
    ../shared.nix
  ];

  networking.hostName = "pc";

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    programs.git.signing.key = "573F8F32BA770BAF";
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}

