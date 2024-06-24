{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
    ./hardware-configuration.nix
    ../shared-desktop.nix
    ../shared.nix
  ];

  networking.hostName = "laptop";

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "gdm-monitors.xml" ''
      <monitors version="2">
        <configuration>
          <logicalmonitor>
            <x>0</x>
            <y>0</y>
            <scale>1</scale>
            <monitor>
              <monitorspec>
                <connector>eDP-1</connector>
                <vendor>BOE</vendor>
                <product>0x074f</product>
                <serial>0x00000000</serial>
              </monitorspec>
              <mode>
                <width>1920</width>
                <height>1080</height>
                <rate>60.012</rate>
              </mode>
            </monitor>
          </logicalmonitor>
        </configuration>
      </monitors>
    ''}"
  ];

  home-manager.users.thiloho = { pkgs, ... }: {
    programs.git.signing.key = "5CF074CA31DD6686";
    home = { stateVersion = "23.05"; };
  };
  system.stateVersion = "23.05";
}
