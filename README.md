# nixos-config

My personal NixOS configuration with flakes, home-manager as a module and multiple devices.

## Useful commands

Get the hardware configuration of the new machine: `nixos-generate-config --show-hardware-config --root /mnt`

Set up a new machine with a nixosConfiguration from a flake git repository: `nixos-install --flake github:<user>/<repository>#<flake>`

Rebuild the current machine: `sudo nixos-rebuild switch --flake .`

Rebuild another machine remotely: `nixos-rebuild switch --flake .#<flake> --target-host <user>@<machine-ip> --use-remote-sudo`
