# Samba file sharing with a public and a private share under ~/Shares.
{ config, ... }:

let
  host = config.networking.hostName;
in {
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = host;
        "netbios name" = host;
        "security" = "user";
        "server signing" = "mandatory";
        "client signing" = "mandatory";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "192.168.2. 192.168.100. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "public" = {
        "path" = "/home/ufuk/Shares/public";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "ufuk";
        "force group" = "users";
      };
      "private" = {
        "path" = "/home/ufuk/Shares/private";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "ufuk";
        "force group" = "users";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
