# ufuk-laptop — primary graphical workstation.
{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/boot/uefi.nix
    ../../modules/desktop

    ../../modules/services/samba.nix
    ../../modules/services/unbound.nix
    ../../modules/services/tailscale.nix
    ../../modules/services/libvirt.nix
  ];

  networking = {
    hostName = "ufuk-laptop";
    networkmanager.dns = "none"; # resolve via the local unbound instance
    nameservers = [ "127.0.0.1" ];
    firewall.allowedTCPPorts = [ 33611 3000 ];
  };

  # Suspend on lid close regardless of power/dock state.
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };

  services.power-profiles-daemon.enable = true;

  # German eID app.
  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  systemd.services = {
    # Keep the battery pinned at 100% (desktop-replacement usage).
    battery-charge-thresholds = {
      description = "Set battery charge thresholds";
      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        echo 100 > /sys/class/power_supply/BATT/charge_control_start_threshold
        echo 100 > /sys/class/power_supply/BATT/charge_control_end_threshold
      '';
    };

    # THM VPN, started manually; reads the password from the clipboard.
    openconnect-vpn = {
      description = "Manual OpenConnect VPN (wl-paste)";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ ]; # empty = doesn't start automatically
      serviceConfig = {
        Type = "simple";
        Environment = [
          "XDG_RUNTIME_DIR=/run/user/1000"
          "WAYLAND_DISPLAY=wayland-1"
        ];
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c '${pkgs.wl-clipboard}/bin/wl-paste | ${pkgs.openconnect}/bin/openconnect --user=uusl33 --passwd-on-stdin vpn.thm.de'
        '';
        Restart = "no";
      };
    };
  };

  system.stateVersion = "24.11";

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    randomizedDelaySec = "1h";
    operation = "switch";
    flake = "/home/ufuk/.config/nixos/";
    flags = [ "--update-input" "nixpkgs" ];
  };
}
