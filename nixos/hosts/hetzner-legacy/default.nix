# Hetzner VPS — legacy (BIOS) boot (template).
#
# Clone this directory per machine, set the hostName, point grub at the right
# disk, and regenerate hardware-configuration.nix with `nixos-generate-config`.
{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/boot/legacy.nix
    ../../modules/roles/server.nix

    ../../modules/services/tailscale.nix
  ];

  networking.hostName = "hetzner-legacy";

  # Disk GRUB is installed to (BIOS/MBR).
  boot.loader.grub.device = "/dev/sda";

  system.stateVersion = "24.11";
}
