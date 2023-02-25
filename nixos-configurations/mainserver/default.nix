# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared.nix
    ];

  # Machine name for networking
  networking = {
    hostName = "mainserver";
    firewall.allowedTCPPorts = [ 5432 ];
  };  

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    enableTCPIP = true;
    authentication = ''
      host all all 0.0.0.0/0 scram-sha-256
    '';
  };

  # Stateful version
  system.stateVersion = "22.11";
}


