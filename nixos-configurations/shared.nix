{ pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Amsterdam";

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  virtualisation.docker.enable = true;

  users.users.thiloho = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };
}


