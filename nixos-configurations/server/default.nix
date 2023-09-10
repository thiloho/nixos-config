{ inputs, pkgs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  nix.settings.trusted-users = [ "thiloho" ];

  environment.systemPackages = with pkgs; [
    nodejs_20
  ];

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
        PegasusIsHere = "24155f74-eb04-4f45-a743-f2b7eb71c6a2";
        BakaZaps = "1888532c-6df7-4514-b96a-99ed4e7684f2";
        Liaxswan = "ccbf3468-a6b4-4d7b-9837-5a2451deca79";
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
        twofactor_enforced = false;
      };
      autoUpdateApps.enable = true;
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

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    ensureDatabases = [ "dcbot" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser auth-method
      local all      all    trust
    '';
  };

  systemd.services.denbot = {
    description = "Thilo's Den discord bot";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    serviceConfig = {
      ExecStart = "${pkgs.nodejs_20}/bin/node index.js --token=$CREDENTIALS_DIRECTORY/bot.token";
      LoadCredential = "bot.token:/var/run/bot-token.txt";
      WorkingDirectory = inputs.denbot;
      Restart = "always";
    };
  };

  users.users.thiloho.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkvr+vT7Ik0fjquxb9xQBfVVWJPgrfC+vJZsyG2V+/G thiloho@pc"
  ];

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}

