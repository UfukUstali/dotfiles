# nar-eksisi — Hetzner VPS (legacy/BIOS), reinstalled from Ubuntu.
#
# The root filesystem keeps the UUID it had under Ubuntu so the disk identity
# is preserved across the wipe. Reformat root with the explicit UUID:
#   mkfs.ext4 -U 5741dd55-20ee-4249-b623-68d3fc2ad616 <root-partition>
{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  # Taken from the machine's original Ubuntu hardware config.
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_scsi" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Root partition — UUID preserved from the previous install.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5741dd55-20ee-4249-b623-68d3fc2ad616";
    fsType = "ext4";
  };

  # Separate persistent data volume — left untouched by the reinstall.
  fileSystems."/mnt/palette" = {
    device = "/dev/disk/by-uuid/293afa53-11cd-43c6-89b4-b006e1619e96";
    fsType = "ext4";
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
