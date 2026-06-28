# nar-eksisi — Hetzner VPS, legacy (BIOS) boot. Reinstalled from Ubuntu,
# keeping the original root filesystem UUID (see hardware-configuration.nix).
{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/boot/legacy.nix
    ../../modules/roles/server.nix

    ../../modules/services/tailscale.nix
  ];

  networking.hostName = "nar-eksisi";

  # Disk GRUB is installed to (BIOS/MBR). virtio_scsi root disk = /dev/sda.
  boot.loader.grub.device = "/dev/sda";

  system.stateVersion = "24.11";
}
