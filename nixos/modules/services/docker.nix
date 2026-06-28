# Docker engine. Safe for headless VPS servers (no libvirt/bridge firewall).
{ ... }:

{
  virtualisation.docker.enable = true;

  users.users.ufuk.extraGroups = [ "docker" ];
}
