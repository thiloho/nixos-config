{ pkgs, ... }:
{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  fonts.packages = with pkgs; [
    jetbrains-mono
  ];

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    excludePackages = [ pkgs.xterm ];
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-connections
    geary
    evince
    gnome-contacts
    gnome-maps
    gnome-music
    snapshot
    simple-scan
  ];

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-themes-extra
  ];

  programs.dconf.enable = true;

  programs.steam.enable = true;

  home-manager.users.thiloho.dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [
        "scale-monitor-framebuffer"
        "variable-refresh-rate"
        "xwayland-native-scaling"
      ];
    };
  };
}
