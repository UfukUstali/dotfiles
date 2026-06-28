# Headless server role: SSH access, firewall, no graphical stack.
{ pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  # Most servers get their address over DHCP.
  networking.useDHCP = pkgs.lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    git
    curl
  ];

  # Add your public keys so you can log in to fresh installs.
  users.users.ufuk.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIlZW/YQmiKtqdQBKl7bc3RfeFc6G+Wtv0YjzOhgI/Ox laptop-nixos"
  ];
}
