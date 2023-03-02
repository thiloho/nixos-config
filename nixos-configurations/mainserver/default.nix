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

  networking = {
    hostName = "mainserver";
    firewall.allowedTCPPorts = [ 80 ];
  };  

  /*
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    enableTCPIP = true;
    authentication = ''
      host all all 0.0.0.0/0 scram-sha-256
    '';
  };
  */

  # Configure Headscale as a controller service for the tailscale VPN
  services = {
    headscale = {
      enable = true;
      settings = {
        listen_addr = "127.0.0.1:8080";
        dns_config.base_domain = "tailscale.thiloho.com";
      };

    };

    nginx = {
      enable = true;
      virtualHosts."mainserver.fritz.box" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
        };
      };   
    };
  };
 
  
  # Stateful version
  system.stateVersion = "22.11";
}


