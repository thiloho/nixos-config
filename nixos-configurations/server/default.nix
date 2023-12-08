{ inputs, pkgs, config, lib, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./hardware-configuration.nix
    ../shared.nix
  ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

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
    minecraft-servers = {
      enable = true;
      eula = true;
      servers = {
        thilo = {
          enable = true;
          autoStart = true;
          package = pkgs.paperServers.paper-1_20_1;
          enableReload = true;
          openFirewall = true;
          whitelist = {
            thilo_ho = "4e4d744d-7748-46bc-add8-b3e8ca3b4cf5";
            PegasusIsHere = "24155f74-eb04-4f45-a743-f2b7eb71c6a2";
            BakaZaps = "1888532c-6df7-4514-b96a-99ed4e7684f2";
            Liaxswan = "ccbf3468-a6b4-4d7b-9837-5a2451deca79";
            rayboo120 = "c65f9422-b972-4583-82b5-2e5a12e789fd";
            AmValo = "a5f4a7d9-daf2-4ec9-b1c9-e39efdfb331e";
            TubiCFW = "fbbd217b-cf9f-404a-a0b4-671155d43222";
            TheRacccooon = "f3a639f2-b82c-49c2-80e5-ccd5cbdc9541";
            _Zyronx = "865f911f-66ae-479f-a65a-8140da82b96e";
          };
          serverProperties = {
            difficulty = 3;
            max-players = 20;
            motd = "§aThilo's survival server";
            white-list = false;
          };
          files = {
            "ops.json".value = [
              {
                uuid = "4e4d744d-7748-46bc-add8-b3e8ca3b4cf5";
                name = "thilo_ho";
                level = 4;
              }
            ];
            "config/paper-world-defaults.yml".value = {
              anticheat = {
                anti-xray = {
                  enabled = true;
                  engine-mode = 2;
                };
              };
            };
            "plugins/TAB/config.yml".value = {
              header-footer = {
                enabled = true;
                header = [
                  "<#FFFFFF>&mx                                     x"
                  ""
                  "&aThilo's survival server"
                  "&7Online players: &f%online%"
                  ""
                ];
                footer = [
                  ""
                  "<#FFFFFF>&mx                                     x"
                ];
              };
              scoreboard-teams = {
                sorting-types = [
                  "GROUPS:admin,mod,premium,default"
                ];
              };
              yellow-number-in-tablist = {
                enabled = false;
              };
            }; 
            "plugins/TAB/groups.yml".value = {
              _DEFAULT_ = {
                tabprefix = "%luckperms-prefix%";
                tagprefix = "%luckperms-prefix%";
                tabsuffix = "%luckperms-suffix%";
                tagsuffix = "%luckperms-suffix%";
              };
            };
            "plugins/Essentials/config.yml".value = {
              ops-name-color = "none";
              chat = {
                format = "{PREFIX}&f{USERNAME}&8: {SUFFIX}{MESSAGE}";
              };
              teleport-cooldown = 90;
              teleport-delay = 5;
              teleport-invulnerability = 5;
              sethome-multiple = {
                "premium" = 2;
              };
            };
            "plugins/LuckPerms/config.yml".value = {
              storage-method = "yaml";
            };
            /*
            "plugins/LuckPerms/yaml-storage/users/4e4d744d-7748-46bc-add8-b3e8ca3b4cf5.yml".value = {
              uuid = "4e4d744d-7748-46bc-add8-b3e8ca3b4cf5";
              name = "thilo_ho";
              primary-group = "admin";
              parents = [
                "admin"
              ];
            };
            */
            "plugins/LuckPerms/yaml-storage/groups/admin.yml".value = {
              name = "admin";
              permissions = [
                "weight.100"
                "essentials.*"
                "luckperms.*"
                "tab.admin"
                "minecraft.command.*"
                "bukkit.command.*"
              ];
              prefixes = [
                {
                  "&8[&cAdmin&8] &f" = {
                    priority = 100;
                  };
                }
              ];
              suffixes = [
                {
                  "&c" = {
                    priority = 100;
                  };
                }
              ];
            };
            "plugins/LuckPerms/yaml-storage/groups/mod.yml".value = {
              name = "mod";
              parents = [ "default" "premium" ];
              permissions = [
                "weight.90"
                "essentials.kick"
                "essentials.kick.notify"
                "essentials.ban"
                "essentials.ban.notify"
                "essentials.tempban"
                "essentials.unban"
                "essentials.mute"
                "essentials.tempmute"
                "essentials.unmute"
                "essentials.fly"
                "essentials.vanish"
                "essentials.socialspy"
                "essentials.seen"
                "essentials.seen.alts"
                "essentials.seen.banreason"
                "essentials.invsee"
                "essentials.tp"
                "essentials.tpoffline"
              ];
              prefixes = [
                {
                  "&8[&dMod&8] &f" = {
                    priority = 90;
                  };
                }
              ];
              suffixes = [
                {
                  "&d" = {
                    priority = 90;
                  };
                }
              ];
            };
            "plugins/LuckPerms/yaml-storage/groups/premium.yml".value = {
              name = "premium";
              parents = [ "default" ];
              permissions = [
                "weight.20"
                "essentials.sethome.multiple.premium"
              ];
              prefixes = [
                {
                  "&8[&6Premium&8] &f" = {
                    priority = 20;
                  };
                }
              ];
              suffixes = [
                {
                  "&f" = {
                    priority = 20;
                  };
                }
              ];
            };
            "plugins/LuckPerms/yaml-storage/groups/default.yml".value = {
              name = "default";
              permissions = [
                {
                  "bukkit.command.version" = {
                    value = false;
                  };
                }
                {
                  "bukkit.command.plugins" = {
                    value = false;
                  };
                }
                {
                  "bukkit.command.help" = {
                    value = false;
                  };
                }
                "weight.10"
                "essentials.tpr"
                "essentials.spawn"
                "essentials.motd"
                "essentials.help"
                "essentials.balance"
                "essentials.afk"
                "essentials.list"
                "essentials.mail"
                "essentials.mail.send"
                "essentials.msg"
                "essentials.sethome"
                "essentials.home"
                "essentials.delhome"
                "essentials.tpa"
                "essentials.tpaccept"
                "essentials.tpdeny"
              ];
              prefixes = [
                {
                  "&8[&aUser&8] &f" = {
                    priority = 10;
                  };
                }
              ];
              suffixes = [
                {
                  "&7" = {
                    priority = 10;
                  };
                }
              ];
            };
            "plugins/GriefPreventionData/config.yml".value = {
              GriefPrevention = {
                Spam = {
                  WarningMessage = "Please refrain from spamming.";
                  BanOffenders = false;
                };
              };
            };
            "plugins/Essentials/motd.txt" = pkgs.writeText "motd.txt" ''
              &m                                                                  
              &6Welcome, {PLAYER}&6!
              &6Type &c/help&6 for a list of commands.
              &6Type &c/list&6 to see who else is online.
              &6Players online:&c {ONLINE} &6- World time:&c {WORLDTIME12}
              &6Discord server: &chttps://discord.gg/SX7fXrDtth
              &m                                                                  
            '';
          };
          symlinks = {
            "server-icon.png" = pkgs.fetchurl {
              url = "https://cdn.discordapp.com/attachments/1142193094729662627/1179544663884046468/server-icon-new.png?ex=657a2b92&is=6567b692&hm=e89f98dc64f027cead19a65d8de5baba14f062ca72d71879bf92eee3b23f0ffc&";
              sha256 = "sha256-nhSGxBvsHbMFsej99RIIQUk5PfP1ErGvBHErhcQHcQ8=";
            };
            "plugins/TAB.jar" = pkgs.fetchurl rec {
              pname = "TAB";
              version = "4.0.9";
              url = "https://github.com/NEZNAMY/${pname}/releases/download/${version}/${pname}.v${version}.jar";
              sha256 = "sha256-xXr7Pc/T+6YfoFUpi2tq09FzCxRp/m8GFQs5qDMkqmc=";
            };
            "plugins/LuckPerms.jar" = pkgs.fetchurl rec {
              pname = "LuckPerms";
              version = "5.4.108";
              url = "https://download.luckperms.net/1521/bukkit/loader/LuckPerms-Bukkit-${version}.jar";
              sha256 = "sha256-TN7HH/5JiG98xBACfuoJZILsiDxU8WX5laNDS3h+qR4=";
            };
            "plugins/Vault.jar" = pkgs.fetchurl {
              pname = "Vault";
              version = "1.7.3";
              url = "https://dev.bukkit.org/projects/vault/files/3007470/download";
              sha256 = "sha256-prXtl/Q6XPW7rwCnyM0jxa/JvQA/hJh1r4s25s930B0=";
            };
            "plugins/EssentialsX.jar" = pkgs.fetchurl rec {
              pname = "EssentialsX";
              version = "2.20.1";
              url = "https://github.com/EssentialsX/Essentials/releases/download/${version}/${pname}-${version}.jar";
              sha256 = "sha256-gC6jC9pGDKRZfoGJJYFpM8EjsI2BJqgU+sKNA6Yb9UI=";
            };
            "plugins/EssentialsXChat.jar" = pkgs.fetchurl rec {
              pname = "EssentialsXChat";
              version = "2.20.1";
              url = "https://github.com/EssentialsX/Essentials/releases/download/${version}/${pname}-${version}.jar";
              sha256 = "sha256-QKpcICQc6zAH68tc+/Gb8sRnsMCQrlDnBlPuh6t3XKY=";
            };
            "plugins/EssentialsXSpawn.jar" = pkgs.fetchurl rec {
              pname = "EssentialsXSpawn";
              version = "2.20.1";
              url = "https://github.com/EssentialsX/Essentials/releases/download/${version}/${pname}-${version}.jar";
              sha256 = "sha256-ZQ18ajOGWgLF/6TrcQ3vKOc9lyya74WysfTnG5vSYaA=";
            };
            "plugins/GriefPrevention.jar" = pkgs.fetchurl {
              pname = "GriefPrevention";
              version = "16.18.1";
              url = "https://dev.bukkit.org/projects/grief-prevention/files/4433061/download";
              hash = "sha256-GwJLJAkrWt7UIMTPYMQ2pCu9/5rExx/a5r2BXuvndOs=";
            };
            "plugins/VoidGen.jar" = pkgs.fetchurl rec {
              pname = "VoidGen";
              version = "2.2.1";
              url = "https://github.com/xtkq-is-not-available/${pname}/releases/download/v${version}/${pname}-${version}.jar";
              hash = "sha256-nOEwEj3GcCXWAPdlvbL98c6nGTv4kg4+AhbF+PwILD4=";
            };
            "plugins/Multiverse-Core.jar" = pkgs.fetchurl rec {
              pname = "Multiverse-Core";
              version = "4.3.12";
              url = "https://github.com/Multiverse/${pname}/releases/download/${version}/multiverse-core-${version}.jar";
              hash = "sha256-mCN6rzXG7nv9lft/OZ73A7PnK/+Oq0iKkEqtnUUwzRA=";
            };
          };
        };
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
        psql -d todos -c "UPDATE user_todo SET is_overdue = true WHERE extract(epoch from CURRENT_DATE) > extract(epoch from due_date) AND is_completed = false AND is_overdue = false"
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
