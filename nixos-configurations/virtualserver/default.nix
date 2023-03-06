# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared.nix
    ];

  networking = {
    hostName = "virtualserver";
    firewall.allowedTCPPorts = [ 80 443 ];
  };  

  # Use ACME for SSL certificates
  security.acme = {
    defaults.email = "thilo.hohlt@tutanota.com";
    acceptTerms = true;
  };

  # Configure Headscale as a controller service for the tailscale VPN
  services = {
    headscale = {
      enable = true;
      settings = {
        listen_addr = "127.0.0.1:8080";
        server_url = "https://tailscale.thiloho.com";
        dns_config.base_domain = "tailscale.thiloho.com";
      };
    };

    nginx = {
      enable = true;
      virtualHosts = {
        "thiloho.com" = {
          enableACME = true;
          forceSSL = true;
          kTLS = true;
          root = inputs.website.packages.${pkgs.stdenv.hostPlatform.system}.default;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8000";
            proxyWebsockets = true;
          };
        };
        "tailscale.thiloho.com" = {
          enableACME = true;
          forceSSL = true;
          kTLS = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8080";
            proxyWebsockets = true;
          };
        };   
      };
    };
  };
  
  # Stateful version
  system.stateVersion = "22.11";
}


