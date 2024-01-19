{ inputs, pkgs, config, lib, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    ./hardware-configuration.nix
    ../shared.nix
  ];

  nix.settings.trusted-users = [ "thiloho" ];

  age.secrets = {
    hedgedoc-environment-file.file =
      ../../secrets/hedgedoc-environment-file.age;
    discord-bot-token.file = ../../secrets/discord-bot-token.age;
    todos-environment-file.file = ../../secrets/todos-environment-file.age;
    "restic/minecraft-environment-file".file =
      ../../secrets/restic/minecraft-environment-file.age;
    "restic/minecraft-repository".file =
      ../../secrets/restic/minecraft-repository.age;
    "restic/minecraft-password".file =
      ../../secrets/restic/minecraft-password.age;
    "restic/hedgedoc-environment-file".file =
      ../../secrets/restic/hedgedoc-environment-file.age;
    "restic/hedgedoc-repository".file =
      ../../secrets/restic/hedgedoc-repository.age;
    "restic/hedgedoc-password".file =
      ../../secrets/restic/hedgedoc-password.age;
    "restic/todos-environment-file".file =
      ../../secrets/restic/todos-environment-file.age;
    "restic/todos-repository".file = ../../secrets/restic/todos-repository.age;
    "restic/todos-password".file = ../../secrets/restic/todos-password.age;
    "restic/discord-bot-environment-file".file =
      ../../secrets/restic/discord-bot-environment-file.age;
    "restic/discord-bot-repository".file =
      ../../secrets/restic/discord-bot-repository.age;
    "restic/discord-bot-password".file =
      ../../secrets/restic/discord-bot-password.age;
  };

  environment.systemPackages = with pkgs; [ nodejs_20 ];

  networking = {
    hostName = "server";
    firewall = {
      allowedTCPPorts = [ 80 443 25565 3232 ];
      allowedUDPPorts = [ 80 443 25565 3232 ];
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
        Liaxswan = "ccbf3468-a6b4-4d7b-9837-5a2451deca79";
      };
      serverProperties = {
        difficulty = 3;
        max-players = 10;
        motd = "Thilo's SMP";
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
    invidious = {
      enable = true;
      port = 3232;
      domain = "invidious.thilohohlt.com";
      nginx.enable = true;
      settings = {
        db.user = "invidious";
        registration_enabled = false;
      };
    };
    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      ensureDatabases = [ "dcbot" "hedgedoc" "todos" "gitea" ];
      ensureUsers = [
        {
          name = "hedgedoc";
          ensureDBOwnership = true;
        }
        {
          name = "gitea";
          ensureDBOwnership = true;
        }
      ];
      authentication = lib.mkForce ''
        #type database DBuser auth-method
        local all      all    trust
      '';
    };
    restic.backups = {
      minecraft-backup = {
        initialize = true;

        environmentFile =
          config.age.secrets."restic/minecraft-environment-file".path;
        repositoryFile = config.age.secrets."restic/minecraft-repository".path;
        passwordFile = config.age.secrets."restic/minecraft-password".path;

        paths = [ "/var/lib/minecraft/world" ];

        pruneOpts = [ "--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12" ];
      };
      hedgedoc-database-backup = {
        initialize = true;

        environmentFile =
          config.age.secrets."restic/hedgedoc-environment-file".path;
        repositoryFile = config.age.secrets."restic/hedgedoc-repository".path;
        passwordFile = config.age.secrets."restic/hedgedoc-password".path;

        paths =
          [ "/var/lib/hedgedoc/uploads" "/var/lib/hedgedoc/hedgedoc.dump" ];

        backupPrepareCommand = ''
          ${config.services.postgresql.package}/bin/pg_dump -U postgres -Fc hedgedoc > /var/lib/hedgedoc/hedgedoc.dump 
        '';

        pruneOpts = [ "--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12" ];
      };
      todos-database-backup = {
        initialize = true;

        environmentFile =
          config.age.secrets."restic/todos-environment-file".path;
        repositoryFile = config.age.secrets."restic/todos-repository".path;
        passwordFile = config.age.secrets."restic/todos-password".path;

        paths = [ "/var/lib/todos.dump" ];

        backupPrepareCommand = ''
          ${config.services.postgresql.package}/bin/pg_dump -U postgres -Fc todos  > /var/lib/todos.dump
        '';

        pruneOpts = [ "--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12" ];
      };
      discord-bot-database-backup = {
        initialize = true;

        environmentFile =
          config.age.secrets."restic/discord-bot-environment-file".path;
        repositoryFile =
          config.age.secrets."restic/discord-bot-repository".path;
        passwordFile = config.age.secrets."restic/discord-bot-password".path;

        paths = [ "/var/lib/dcbot.dump" ];

        backupPrepareCommand = ''
          ${config.services.postgresql.package}/bin/pg_dump -U postgres -Fc dcbot  > /var/lib/dcbot.dump
        '';

        pruneOpts = [ "--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12" ];
      };
    };
  };

  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "thilo.hohlt@tutanota.com";
    };
  };

  systemd.services = {
    todoapp = {
      description = "Todo application to plan your daily tasks effectively";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        Environment =
          "PORT=5173 DOTENV_CONFIG_PATH=${config.age.secrets.todos-environment-file.path}";
        ExecStart = "${pkgs.nodejs_20}/bin/node -r dotenv/config .";
        WorkingDirectory = inputs.todos.packages.${pkgs.system}.default;
        Restart = "always";
      };
    };
    todoapp-check-due-dates = {
      description =
        "Set is_overdue for todo in database to true if todo is overdue";
      wantedBy = [ "timers.target" ];
      path = [ pkgs.postgresql_15 ];
      script = ''
        psql -d todos -c "UPDATE user_todo SET is_overdue = true WHERE DATE_TRUNC('day', NOW() AT TIME ZONE 'CET') > due_date AND is_completed = false AND is_overdue = false"
      '';
      serviceConfig = { User = "postgres"; };
      partOf = [ "todoapp.service" ];
      startAt = "daily";
    };
    denbot = {
      description = "Thilo's Den discord bot";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStartPre = [
          "${pkgs.nodejs_20}/bin/node dbInit.js"
          "${pkgs.nodejs_20}/bin/node deploy-commands.js --token=${config.age.secrets.discord-bot-token.path} --clientId=1142441791459704912"
        ];
        ExecStart =
          "${pkgs.nodejs_20}/bin/node index.js --token=${config.age.secrets.discord-bot-token.path}";
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
    home = { stateVersion = "23.05"; };
  };
  system.stateVersion = "23.05";
}
