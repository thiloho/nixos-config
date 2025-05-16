{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.05"
  ];

  networking = {
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [ 53317 ];
    };
  };

  time.timeZone = "Europe/Berlin";

  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = "$y$j9T$gdQiD91dRc1rEURkntnkh1$9VvI8xhvCMqhSSOeOkiSnjHsQVUOOH/4Sbou.w6P5TC";
      thiloho = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "docker"
        ];
        hashedPassword = "$y$j9T$0wgXXBJMy5lzuwmdvx5Lb.$G5JmfDXeXzH7sq66R.clvmlovuh1ZsZMf1SfDsWpNcB";
      };
    };
  };
}
