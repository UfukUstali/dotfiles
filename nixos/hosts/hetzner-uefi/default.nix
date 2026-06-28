# Hetzner VPS — UEFI boot (template).
#
# Clone this directory per machine, set the hostName, and regenerate
# hardware-configuration.nix with `nixos-generate-config`.
{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/boot/uefi.nix
    ../../modules/roles/server.nix

    ../../modules/services/tailscale.nix
  ];

  networking.hostName = "hetzner-uefi";

  system.stateVersion = "24.11";
}
