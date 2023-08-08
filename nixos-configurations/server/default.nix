{ inputs, pkgs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  nix.settings.trusted-users = [ "thiloho" ];

  networking = {
    hostName = "server";
    firewall = {
      allowedTCPPorts = [ 80 443 25565 ];
    };
  };

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
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
        "cloud.thilohohlt.com" = {
          enableACME = true;
          forceSSL = true;
        };
      };
    };
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud27;
      hostName = "cloud.thilohohlt.com";
      database.createLocally = true;
      https = true;
      configureRedis = true;
      config = {
        dbtype = "pgsql";
        adminuser = "thohlt";
        adminpassFile = "/var/run/nextcloud-pass.txt";
        defaultPhoneRegion = "DE";
      };
      extraOptions = {
        mail_smtpmode = "sendmail";
        mail_sendmailmode = "pipe";
      };
      extraApps = with pkgs.nextcloud27Packages.apps; {
        inherit tasks forms spreed;
      };
      extraAppsEnable = true;
    };
  };

  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "thilo.hohlt@tutanota.com";
    };
    sudo.extraConfig = ''
      %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
    '';
  };

  users.users.thiloho.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKYk3OUO/X8xRcLpUBQ3oq8BYlgnvsCIInhbfEYAYyBB thiloho@pc"
  ];

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}

