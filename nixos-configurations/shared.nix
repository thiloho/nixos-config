{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Amsterdam";

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  users.users.thiloho = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };
}


