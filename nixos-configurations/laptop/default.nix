{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
    ./hardware-configuration.nix
    ../shared-desktop.nix
    ../shared.nix
  ];

  networking.hostName = "laptop";

  home-manager.users.thiloho = { pkgs, ... }: {
    programs.git.signing.key = "1142F33FFA8ADAAC";
    home = {
      packages = with pkgs;
        [
          # ciscoPacketTracer8
        ];
      stateVersion = "23.05";
    };
  };
  system.stateVersion = "23.05";
}
