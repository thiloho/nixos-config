{ inputs, pkgs, ... }:

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
      allowedTCPPorts = [
        5173
        8081
      ];
      allowedUDPPorts = [
        5173
        8081
      ];
    };
  };

  boot.kernelParams = [ "amd_iommu=on" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  programs.ssh.extraConfig = ''
    Host 128.140.75.240
      ForwardAgent yes
  '';

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  programs.virt-manager.enable = true;

  programs.adb.enable = true;
  users.users.thiloho.extraGroups = [ "adbusers" ];

  # Use same monitor settings for GDM as for GNOME user
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "gdm-monitors.xml" ''
      <monitors version="2">
        <configuration>
          <logicalmonitor>
            <x>0</x>
            <y>0</y>
            <scale>2</scale>
            <primary>yes</primary>
            <monitor>
              <monitorspec>
                <connector>DP-3</connector>
                <vendor>GBT</vendor>
                <product>M27U</product>
                <serial>23323B000497</serial>
              </monitorspec>
              <mode>
                <width>3840</width>
                <height>2160</height>
                <rate>160.000</rate>
              </mode>
            </monitor>
          </logicalmonitor>
        </configuration>
      </monitors>
    ''}"
  ];

  home-manager.users.thiloho =
    { pkgs, lib, ... }:
    {
      programs.git.signing.key = "5FED02C109365F87";
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
