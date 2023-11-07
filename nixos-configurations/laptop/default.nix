{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
    ./hardware-configuration.nix
    ../shared-desktop.nix
    ../shared.nix
  ];

  networking.hostName = "laptop";

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    ensureDatabases = [ "dcbot" "todos" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser auth-method
      local all      all    trust
    '';
  };

  home-manager.users.thiloho = { pkgs, ... }: {
    programs.git.signing.key = "1142F33FFA8ADAAC";
    home = {
      packages = with pkgs; [
        # ciscoPacketTracer8
      ];
      stateVersion = "23.05";
    };
  };
  system.stateVersion = "23.05";
}
