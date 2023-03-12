{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared.nix
    ];

  age.secrets = {
    mainserver-root-password.file = ../../secrets/mainserver-root-password.age;
    mainserver-thiloho-password.file = ../../secrets/mainserver-thiloho-password.age;
    mainserver-firefox-syncserver-secrets.file = ../../secrets/mainserver-firefox-syncserver-secrets.age;
    mainserver-wireguard-private-key.file = ../../secrets/mainserver-wireguard-private-key.age;
  };


  networking = {
    hostName = "mainserver";
    firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 51820 ];
    };
    # nat = {
    #   enable = true;
    #   externalInterface = "eth0";
    #   internalInterfaces = [ "wg0" ];
    # };
    # wireguard.interfaces = {
    #   wg0 = {
    #     ips = [ "10.100.0.1/24" ];
    #     listenPort = 51820;
    #     postSetup = ''
    #       ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
    #     '';
    #     postShutdown = ''
    #       ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
    #     '';
    #     privateKeyFile = config.age.secrets.mainserver-wireguard-private-key.path;
    #     peers = [
    #       {
    #         publicKey = "LCxf7Ca6aEn20rxDn6FiaGw3sdbwnhbi7FdW3dtf7SM=";
    #         allowedIPs = [ "10.100.0.2/32" ];
    #       }
    #     ];
    #   };
    # };
  };  

  # users.users.root.passwordFile = config.age.secrets.mainserver-root-password.path;    
  # users.users.thiloho.passwordFile = config.age.secrets.mainserver-thiloho-password.path;

  # Use ACME for SSL certificates
  security.acme = {
    defaults.email = "thilo.hohlt@tutanota.com";
    acceptTerms = true;
  };

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

    # mysql.package = pkgs.mariadb; 

    # firefox-syncserver = {
    #   enable = true;
    #   secrets = config.age.secrets.mainserver-firefox-syncserver-secrets.path;
    #   singleNode = {
    #     enable = true;
    #     hostname = "firefox-syncserver.thiloho.com";
    #     enableNginx = true;
    #     enableTLS = true;
    #   };
    # };
  };

  # Stateful version
  system.stateVersion = "22.11";
}


