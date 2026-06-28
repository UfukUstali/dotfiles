# libvirt/KVM virtualisation for dev workstations.
#
# Pulls in Docker too, and trusts the docker/libvirt bridge interfaces in the
# firewall — only wanted on dev machines, never on production VPS servers.
{ pkgs, ... }:

{
  imports = [ ./docker.nix ];

  virtualisation.libvirtd.enable = true;

  users.users.ufuk.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [
    virt-manager
    virtiofsd
  ];

  # Trust the bridge interfaces created by docker/libvirt.
  networking.firewall.trustedInterfaces = [ "virbr0" "docker0" "docker_gwbridge" "br-*" ];
}
