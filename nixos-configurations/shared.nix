{ config, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable experimental features nix-command and flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.systemPackages = with pkgs; [
    headscale
  ];

  # Allow proprietary software
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Setting a user account
  users.users.thiloho = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # Enable OpenSSH for remote logins
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # Enable tailscale for remote access (VPN)
  services.tailscale.enable = true;
}
