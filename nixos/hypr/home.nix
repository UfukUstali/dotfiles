{ lib, pkgs, ...}: {

  home.packages = with pkgs; [
    hyprpicker
    hyprcursor
    hyprpolkitagent

    clipse
  ];

  systemd.user = {
    enable = true;
    startServices = "sd-switch";
    services = {
      hyprpolkitagent = lib.mkForce {
        Unit = {
          Description = "Hyprland Polkit Authentication Agent";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
          Slice = "session.slice";
          TimeoutStopSec = "5sec";
          Restart = "on-failure";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };

      clipse = lib.mkForce {
        Unit = {
          Description = "Clipse listener";
          Documentation = "https://github.com/savedra1/clipse";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.clipse}/bin/clipse -listen";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
