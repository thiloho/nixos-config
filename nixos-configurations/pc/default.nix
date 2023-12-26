{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    ./hardware-configuration.nix
    ../shared-desktop.nix
    ../shared.nix
  ];

  networking = {
    hostName = "pc";
    firewall = {
      allowedTCPPorts = [ 5173 ];
      allowedUDPPorts = [ 5173 ];
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    ensureDatabases = [ "dcbot" "todos" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser auth-method
      local all      all    trust
    '';
  };

  programs.adb.enable = true;
  users.users.thiloho.extraGroups = [ "adbusers" ];

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    programs.git.signing.key = "5ECD00BDC15A987E";
    home = {
      packages = with pkgs; [
        blender
        inkscape
      ];
      stateVersion = "23.05";
    };
  };
  system.stateVersion = "23.05";
}

