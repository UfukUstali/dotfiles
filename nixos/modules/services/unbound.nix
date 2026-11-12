# Local validating DNS resolver forwarding over TLS to Cloudflare, with a few
# split-horizon zones. Hosts using this should set:
#   networking.nameservers = [ "127.0.0.1" ];
#   networking.networkmanager.dns = "none";
{ pkgs, ... }:

{
  # On resume the network route isn't up yet, so restarting unbound at that
  # moment just fails to reach the upstream (can't prime the DNSSEC trust
  # anchor) and marks it down in the infra cache for infra-host-ttl. Restarting
  # on the resume event is therefore a race. Instead, restart unbound when
  # NetworkManager reports the connection is actually up, and keep infra-host-ttl
  # short so unbound also recovers on its own if a restart is ever missed.
  #
  # Only react to the real uplink: at boot every virtual interface (lo, docker,
  # libvirt, tailscale bridges) fires its own "up", and restarting on each one
  # trips unbound's start limit and leaves it failed.
  networking.networkmanager.dispatcherScripts = [
    {
      type = "basic";
      source = pkgs.writeShellScript "unbound-restart-on-net-up" ''
        case "$2" in
          up)
            case "$(${pkgs.networkmanager}/bin/nmcli -g GENERAL.TYPE device show "$1" 2>/dev/null)" in
              wifi | ethernet) ;;
              *) exit 0 ;;
            esac
            ;;
          connectivity-change)
            [ "$CONNECTIVITY_STATE" = FULL ] || exit 0
            ;;
          *) exit 0 ;;
        esac
        ${pkgs.systemd}/bin/systemctl try-restart unbound.service
      '';
    }
  ];

  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" "::1" ];
        access-control = [
          "127.0.0.0/8 allow"
          "::1 allow"
        ];
        qname-minimisation = "yes";
        prefetch = "yes";
        hide-identity = "yes";
        hide-version = "yes";
      };

      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "1.1.1.1@853"
            "1.0.0.1@853"
          ];
          forward-tls-upstream = "yes";
        }
        {
          name = "youtrack.mni.thm.de";
          forward-addr = [ "192.168.186.83" ];
        }
        {
          name = "ts.net.";
          forward-addr = [ "100.100.100.100" ];
        }
      ];
    };
  };
}
