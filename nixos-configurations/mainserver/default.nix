{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared.nix
    ];

  networking = {
    hostName = "mainserver";
    firewall.allowedTCPPorts = [ 80 443 ];
  };  

  age.secrets = {
    mainserver-root-password.file = ../../secrets/mainserver-root-password.age;
    mainserver-thiloho-password.file = ../../secrets/mainserver-thiloho-password.age;
    mainserver-firefox-syncserver-secrets.file = ../../secrets/mainserver-firefox-syncserver-secrets.age;
  };

  users.users.root.passwordFile = config.age.secrets.mainserver-root-password.path;    
  users.users.thiloho.passwordFile = config.age.secrets.mainserver-thiloho-password.path;


  # Use ACME for SSL certificates
  security.acme = {
    defaults.email = "thilo.hohlt@tutanota.com";
    acceptTerms = true;
  };

  # Configure Headscale as a controller service for the tailscale VPN
  services = {
    nginx = {
      enable = true;
      virtualHosts = {
        "thiloho.com" = {
          enableACME = true;
          forceSSL = true;
          root = inputs.website.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };
        "gitea.thiloho.com" = {
          enableACME = true;
          forceSSL = true;          
          locations."/" = {
            proxyPass = "http://127.0.0.1:3000";
          };
        };
      };
    };

    gitea = {
      enable = true;
      domain = "gitea.thiloho.com";
      rootUrl = "https://gitea.thiloho.com";
      settings.service.DISABLE_REGISTRATION = true;
    };

    mysql.package = pkgs.mariadb; 

    firefox-syncserver = {
      enable = true;
      secrets = config.age.secrets.mainserver-firefox-syncserver-secrets.path;
      singleNode = {
        enable = true;
        hostname = "firefox-syncserver.thiloho.com";
        enableNginx = true;
        enableTLS = true;
      };
    };
  };
  
  # Stateful version
  system.stateVersion = "22.11";
}


