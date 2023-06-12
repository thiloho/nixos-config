{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  networking.hostName = "laptop";

  home-manager.users.thiloho = { pkgs, ... }: {
    programs.git = {
      signing = {
        key = "86C465C22C8A4D56";
      };
    };
  };
}
