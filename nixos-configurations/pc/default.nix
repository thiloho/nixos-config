{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    ./hardware-configuration.nix

    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/development.nix
    ../../modules/home.nix
    ../../modules/media.nix
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

  boot = {
    initrd.luks.devices.cryptroot = {
      device = "/dev/disk/by-uuid/1202158c-cf4a-49f5-83f6-d54af16bca65";
    };
    kernelParams = [ "amd_iommu=on" ];
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ pkgs.linuxPackages_latest.v4l2loopback ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Webcam"
    '';
  };

  environment.sessionVariables = {
    MUTTER_DEBUG_DISABLE_HW_CURSORS = "1";
  };

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

  home-manager.users.thiloho = {
    programs.git.signing.key = "273D6150B9741CCF";
    xdg.desktopEntries.andcam = {
      name = "Android Virtual Camera";
      exec = "${pkgs.writeScript "andcam" ''
        ${pkgs.android-tools}/bin/adb start-server
        ${pkgs.scrcpy}/bin/scrcpy --camera-id=0 --video-source=camera --no-audio --v4l2-sink=/dev/video0 -m1024
      ''}";
    };
    home.stateVersion = "24.11";
  };

  system.stateVersion = "24.11";
}
