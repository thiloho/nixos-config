{ config, pkgs, inputs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable experimental features nix-command and flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.x86_64-linux.default
    wireguard-tools
  ];

  users.mutableUsers = false;

  # Allow proprietary software
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Setting a user account
  users.users.thiloho = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvwRN8uxppJn6qw+p+2oMR3fgd9k5EqiFcE69Wh3K1T thiloho@mainpc" ];
  };

  # Enable OpenSSH for remote logins
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Enable tailscale for remote access (VPN)
  services.tailscale.enable = true;
}
