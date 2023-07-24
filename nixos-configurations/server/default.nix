{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  services.minecraft-server = {
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

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}

