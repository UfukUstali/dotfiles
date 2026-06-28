# Legacy (BIOS / MBR) boot via GRUB.
#
# Set the target disk per host, e.g. in the host's default.nix:
#   boot.loader.grub.device = "/dev/sda";
{ lib, ... }:

{
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    device = lib.mkDefault "/dev/sda";
  };
}
