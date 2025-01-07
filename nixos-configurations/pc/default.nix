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

  boot.initrd = {
    luks.devices = {
      cryptroot = {
        device = "/dev/disk/by-uuid/1202158c-cf4a-49f5-83f6-d54af16bca65";
      };
    };
  };

  environment.sessionVariables = {
    MUTTER_DEBUG_FORCE_KMS_MODE = "simple";
  };

  boot.kernelParams = [ "amd_iommu=on" ];

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
                <rate>150.000</rate>
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
      programs.git.signing.key = "273D6150B9741CCF";
      home = {
        packages = with pkgs; [
          inkscape
        ];
        stateVersion = "24.11";
      };
    };
  system.stateVersion = "24.11";
}
