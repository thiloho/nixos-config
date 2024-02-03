{ pkgs, inputs, lib, ... }:

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
      allowedTCPPorts = [ 5173 8081 53317 ];
      allowedUDPPorts = [ 5173 8081 53317 ];
    };
  };

  boot.kernelParams = [ "amd_iommu=on" ];

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  programs.virt-manager.enable = true;

  services = {
    syncthing = {
      enable = true;
      user = "thiloho";
      overrideFolders = true;
      configDir = "/home/thiloho/.config/syncthing";
      dataDir = "/home/thiloho";
      openDefaultPorts = true;
    };
    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      ensureDatabases = [ "dcbot" "todos" ];
      authentication = lib.mkForce ''
        local all all trust
        host all all ::1/128 trust
      '';
    };
  };

  programs.adb.enable = true;
  users.users.thiloho.extraGroups = [ "adbusers" ];

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    programs.git.signing.key = "5ECD00BDC15A987E";
    home = {
      packages = with pkgs; [ blender inkscape localsend ];
      stateVersion = "23.05";
    };
  };
  system.stateVersion = "23.05";
}

