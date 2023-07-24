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

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users.thiloho.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAy1KnXinQJNcGpWTe1jifNuUEfKZRmyshVX5fPEWR19 thiloho@pc"
  ];

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05";
}

