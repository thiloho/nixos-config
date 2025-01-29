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
      dynamic-workspaces = true;
      workspaces-only-on-primary = false;
      edge-tiling = true;
      center-new-windows = true;
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "com.github.neithern.g4music.desktop"
        "firefox-devedition.desktop"
        "mullvad-browser.desktop"
        "mullvad-vpn.desktop"
        "tutanota-desktop.desktop"
        "org.gnome.SystemMonitor.desktop"
        "org.gnome.Console.desktop"
        "codium.desktop"
        "org.gnome.Nautilus.desktop"
      ];
      disable-user-extensions = true;
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = false;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      accent-color = "purple";
      enable-hot-corners = true;
      locate-pointer = true;
      gtk-theme = "Adwaita-dark";
    };

    "org/gnome/desktop/background" =
      let
        wallpaperImg = pkgs.fetchurl {
          url = "https://images.unsplash.com/photo-1585149599548-04b9ad8c1b53?q=80&w=3874&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
          hash = "sha256-sbjIPX25Kyi5tyxRfGhk1iRMIqhbFKbEY2AtA68+k4Q=";
        };
      in
      {
        picture-uri = "${wallpaperImg}";
        picture-uri-dark = "${wallpaperImg}";
      };
  };
}
