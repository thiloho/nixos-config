{ pkgs, ... }:
{
  virtualisation.docker.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };
  programs.virt-manager.enable = true;

  programs.adb.enable = true;
  users.users.thiloho.extraGroups = [ "adbusers" ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      nodejs
      nodePackages.pnpm
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.java.enable = true;
}
