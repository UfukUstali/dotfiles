# UEFI boot via systemd-boot. Requires an ESP mounted at /boot.
{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
