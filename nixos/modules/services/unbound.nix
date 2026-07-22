# Local validating DNS resolver forwarding over TLS to Cloudflare, with a few
# split-horizon zones. Hosts using this should set:
#   networking.nameservers = [ "127.0.0.1" ];
#   networking.networkmanager.dns = "none";
{ pkgs, ... }:

{
  # After a suspend/resume the TLS upstream connections are dead and unbound
  # has marked the upstreams unreachable in its infra cache (retried only after
  # infra-host-ttl, 15m by default), so DNS stays broken well after the network
  # is back. Restart unbound on resume to clear that stale state.
  systemd.services.unbound-restart-on-resume = {
    description = "Restart unbound after resume to clear stale upstream state";
    after = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl try-restart unbound.service";
    };
  };

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
