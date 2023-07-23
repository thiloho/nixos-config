{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  networking = {
    hostName = "server";
    interfaces = {
      enp41s0.ipv6.addresses = [{
        address = "2a01:4f8:a0:8246::1";
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp41s0";
    };
  };

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}

