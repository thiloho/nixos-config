{ inputs, ... }:

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
      allowedTCPPorts = [ 5173 8081 ];
      allowedUDPPorts = [ 5173 8081 ];
    };
  };

  boot.kernelParams = [ "amd_iommu=on" ];

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  programs.virt-manager.enable = true;

  programs.adb.enable = true;
  users.users.thiloho.extraGroups = [ "adbusers" ];

  home-manager.users.thiloho = { pkgs, lib, ... }: {
    programs.git.signing.key = "5ECD00BDC15A987E";
    home = {
      packages = with pkgs; [ blender inkscape chromium ];
      stateVersion = "23.05";
    };
  };
  system.stateVersion = "23.05";
}

