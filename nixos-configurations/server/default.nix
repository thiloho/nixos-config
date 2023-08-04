{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  networking = {
    hostName = "server";
    firewall = {
      allowedTCPPorts = [ 80 443 25565 ];
    };
  };

  services = {
    minecraft-server = {
      enable = true;
      eula = true;
      declarative = true;
      openFirewall = true;
      whitelist = {
        thilo_ho = "4e4d744d-7748-46bc-add8-b3e8ca3b4cf5";
      };
      serverProperties = {
        difficulty = 3;
        max-players = 10;
        motd = "Minecraft server of Thilo.";
        white-list = true;
      };
    };
    openssh.enable = true;
    nginx = {
      enable = true;
      virtualHosts = {
        "thilohohlt.com" = {
          enableACME = true;
          forceSSL = true;
          root = inputs.website;
        };
        "aurora.thilohohlt.com" = {
          enableACME = true;
          forceSSL = true;
          root = inputs.aurora-blog-template.packages.${pkgs.system}.default;
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "thilo.hohlt@tutanota.com";
  };

  users.users.thiloho.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH22p7+RCaEYZjxWzZ3SE9byCkqfT9SPq7Ht47XmCM9s thiloho@ThilosPC"
  ];

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}

