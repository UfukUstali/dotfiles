# ufuk-desktop — graphical workstation (template).
#
# After cloning to real hardware, regenerate hardware-configuration.nix with
# `nixos-generate-config --show-hardware-config`.
{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/boot/uefi.nix
    ../../modules/desktop

    ../../modules/services/samba.nix
    ../../modules/services/tailscale.nix
    ../../modules/services/libvirt.nix
  ];

  networking.hostName = "ufuk-desktop";

  system.stateVersion = "24.11";
}
