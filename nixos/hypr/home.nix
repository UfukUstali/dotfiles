{ lib, pkgs, hyprlandPkgs, hy3Pkgs, hyprDyCursorsPkgs, hyprspacePkgs, ...}: {

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprlandPkgs.hyprland;
    systemd.enable = false;
    settings = {};
    plugins = [
      hy3Pkgs.hy3
      hyprspacePkgs.Hyprspace
      hyprDyCursorsPkgs.hypr-dynamic-cursors
    ];
    extraConfig = ''
      source = ./main-uwsm.conf
    '';
  };

  home.packages = with pkgs; [
    hyprpicker
    hyprcursor
    hyprpaper
    hypridle
    hyprpolkitagent

    waybar
    clipse
    swaynotificationcenter
    wlogout
  ];

  systemd.user = {
    enable = true;
    startServices = "sd-switch";
    services = {
      hyprpaper = lib.mkForce {
        Unit = {
          Description = "Fast, IPC-controlled wallpaper utility for Hyprland.";
          Documentation = "https://wiki.hyprland.org/Hypr-Ecosystem/hyprpaper/";
          PartOf = [ "graphical-session.target" ];
          Requires = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
          Slice = "session.slice";
          Restart = "on-failure";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };

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

      hypridle = lib.mkForce {
        Unit = {
          Description = "Hyprland's idle daemon";
          Documentation = "https://wiki.hyprland.org/Hypr-Ecosystem/hypridle";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.hypridle}/bin/hypridle";
          Restart = "on-failure";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };

      waybar = lib.mkForce {
        Unit = {
          Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
          Documentation = "https://github.com/Alexays/Waybar/wiki/";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
          Requisite = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${pkgs.waybar}/bin/waybar";
          ExecReload = "kill -SIGUSR2 $MAINPID";
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

      swaync = lib.mkForce {
        Unit = {
          Description = "Swaync notification daemon";
          Documentation = "https://github.com/ErikReider/SwayNotificationCenter";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          Type = "dbus";
          BusName = "org.freedesktop.Notifications";
          ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
          ExecReload = ''
            ${pkgs.swaynotificationcenter}/bin/swaync-client --reload-config;
            ${pkgs.swaynotificationcenter}/bin/swaync-client --reload-css
          '';
          Restart = "on-failure";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
