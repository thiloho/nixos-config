{ inputs, pkgs, ... }:

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
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
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
        "collab.thilohohlt.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = "http://localhost:3300";
          locations."/socket.io/" = {
            proxyPass = "http://localhost:3300";
            proxyWebsockets = true;
            extraConfig = "proxy_ssl_server_name on;";
          };
        };
      };
    };
    hedgedoc = {
      enable = true;
      settings = {
        port = 3300;
        domain = "collab.thilohohlt.com";
        db = {
          dialect = "postgres";
          host = "/run/postgresql";
          database = "hedgedoc";
        };
        protocolUseSSL = true;
      };
    };
    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      ensureDatabases = [ "dcbot" "hedgedoc" ];
      ensureUsers = [
        {
          name = "hedgedoc";
          ensurePermissions."DATABASE hedgedoc" = "ALL PRIVILEGES";
        }
      ];
      authentication = pkgs.lib.mkOverride 10 ''
        #type database DBuser auth-method
        local all      all    trust
      '';
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

  systemd.services.denbot = {
    description = "Thilo's Den discord bot";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    serviceConfig = {
      Type = "simple";
      ExecStartPre = [
        "${pkgs.nodejs_20}/bin/node dbInit.js"
        "${pkgs.nodejs_20}/bin/node deploy-commands.js --token=%d/bot.token --clientId=1142441791459704912"
      ];
      ExecStart = "${pkgs.nodejs_20}/bin/node index.js --token=%d/bot.token";
      LoadCredential = "bot.token:/var/run/bot-token.txt";
      WorkingDirectory = inputs.denbot.packages.${pkgs.system}.default;
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