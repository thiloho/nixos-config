{ inputs, pkgs, config, lib, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    ./hardware-configuration.nix
    ../shared.nix
  ];

  nix.settings.trusted-users = [ "thiloho" ];

  age.secrets.hedgedoc-environment-file.file = ../../secrets/hedgedoc-environment-file.age;
  age.secrets.discord-bot-token.file = ../../secrets/discord-bot-token.age;
  age.secrets.todos-environment-file.file = ../../secrets/todos-environment-file.age;

  environment.systemPackages = with pkgs; [
    nodejs_20
  ];

  networking = {
    hostName = "server";
    firewall = {
      allowedTCPPorts = [ 80 443 25565 ];
      allowedUDPPorts = [ 80 443 25565 ];
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
    terraria = {
      enable = true;
      maxPlayers = 10;
      messageOfTheDay = "Terraria server of Thilo";
      openFirewall = true;
      secure = true;
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
        "todos.thilohohlt.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = "http://localhost:5173";
        };
        "git.thilohohlt.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = "http://localhost:3001";
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
        allowAnonymous = false;
        allowEmailRegister = false;
        email = false;
      };
      environmentFile = config.age.secrets.hedgedoc-environment-file.path;
    };
    gitea = {
      enable = true;
      appName = "Gitea instance of Thilo";
      database = {
        type = "postgres";
        host = "/run/postgresql";
      };
      settings.service.DISABLE_REGISTRATION = true;
      settings.server = {
        DOMAIN = "thilohohlt.com";
        ROOT_URL = "https://git.thilohohlt.com";
        HTTP_PORT = 3001;
      };
    };
    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      ensureDatabases = [ "dcbot" "hedgedoc" "todos" "gitea" ];
      # ALTER DATABASE mydb OWNER TO admin;
      # The user also needs to be the owner of the specific database, which cannot be declaratively set up from this module
      ensureUsers = [
        {
          name = "hedgedoc";
          ensurePermissions."DATABASE hedgedoc" = "ALL PRIVILEGES";
        }
        {
          name = "gitea";
          ensurePermissions."DATABASE gitea" = "ALL PRIVILEGES";
        }
      ];
      authentication = lib.mkForce ''
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

  systemd.services = {
    todoapp = {
      description = "Todo application to plan your daily tasks effectively";
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      serviceConfig = {
        Type = "simple";
        Environment = "PORT=5173 DOTENV_CONFIG_PATH=${config.age.secrets.todos-environment-file.path}";
        ExecStart = "${pkgs.nodejs_20}/bin/node -r dotenv/config .";
        WorkingDirectory = inputs.todos.packages.${pkgs.system}.default;
        Restart = "always";
      };
    };
    todoapp-check-due-dates = {
      description = "Set is_overdue for todo in database to true if todo is overdue";
      path = [
        pkgs.postgresql_15
      ];
      script = ''
        psql -d todos -c "UPDATE user_todo SET is_overdue = true WHERE due_date::date < (CURRENT_DATE + INTERVAL '1 hour') AND is_completed = false AND is_overdue = false"
      '';
      serviceConfig = {
        User = "postgres";
      };
      wantedBy = ["timers.target"];
      partOf = [ "todoapp.service" ];
      startAt = "daily";
    };
    denbot = {
      description = "Thilo's Den discord bot";
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      serviceConfig = {
        Type = "simple";
        ExecStartPre = [
          "${pkgs.nodejs_20}/bin/node dbInit.js"
          "${pkgs.nodejs_20}/bin/node deploy-commands.js --token=${config.age.secrets.discord-bot-token.path} --clientId=1142441791459704912"
        ];
        ExecStart = "${pkgs.nodejs_20}/bin/node index.js --token=${config.age.secrets.discord-bot-token.path}";
        WorkingDirectory = inputs.denbot.packages.${pkgs.system}.default;
        Restart = "always";
      };
    };
  };

  users.users.thiloho.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkvr+vT7Ik0fjquxb9xQBfVVWJPgrfC+vJZsyG2V+/G thiloho@pc"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5jOELdhQ85uKV8l2QkbLhjdPr142p1AmPzpawaJ7ws thiloho@laptop"
  ];

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    home = {
      stateVersion = "23.05";
    };
  };
  system.stateVersion = "23.05";
}
