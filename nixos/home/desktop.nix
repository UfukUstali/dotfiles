# Graphical home configuration: GUI apps, dev toolchains, theming and user
# services. Imported by workstation hosts only.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # fonts and themes
    font-awesome
    nerd-fonts.caskaydia-mono
    nerd-fonts.caskaydia-cove
    nordzy-cursor-theme

    # common apps/utils
    google-chrome
    vscode
    remmina
    anydesk
    playerctl
    onlyoffice-desktopeditors
    ghostty
    sioyek
    tectonic-unwrapped
    grim
    wf-recorder
    slurp
    satty
    zoom-us
    t3code
    claude-code

    # thm vpn
    openconnect

    # other
    wev
    hw-probe
    ripdrag
    mprocs
    rquickshare
    just
    ghidra

    # languages
    gcc
    go
    rustc
    cargo
    bun
    texliveFull
    texpresso
    (rWrapper.override {
      packages = with rPackages; [
        tidyverse psych car MASS lubridate broom ggpubr
        lmtest sandwich lme4 glmnet survival forecast
        knitr kableExtra languageserver
        readr readxl dplyr ggplot2
      ];
    })
    jdk
    maven
    python3

    # soon(TM)
    # scrcpy
    # gnome-network-displays
  ];

  programs.caelestia = {
    enable = true;
    settings = {
      services.weatherLocation = "giessen";
      general.idle.timeouts = [
        {
          idleAction = "hl.dsp.dpms({ action = \"off\" })";
          onlyWhenLocked = true;
          returnAction = "hl.dsp.dpms({ action = \"on\" })";
          timeout = 60;
        }
        {
          idleAction = "lock";
          timeout = 1200;
        }
        {
          idleAction = "hl.dsp.dpms({ action = \"off\" })";
          returnAction = "hl.dsp.dpms({ action = \"on\" })";
          timeout = 1260;
        }
      ];
      appearance = {
        anim.durations.scale = 0.3;
        padding.scale = 0.9;
        rounding.scale = 0.5;
        spacing.scale = 0.5;
      };
      bar = {
        activeWindow = {
          compact = true;
          inverted = true;
        };
        popouts = {
          activeWindow = false;
          statusIcons = true;
          tray = true;
        };
        status = {
          showAudio = false;
          showBluetooth = true;
          showKbLayout = false;
          showMicrophone = true;
        };
        tray = {
          background = false;
          compact = true;
          recolour = false;
        };
        workspaces = {
          activeIndicator = true;
          occupiedBg = false;
          perMonitorWorkspaces = false;
          showWindows = false;
          shown = 5;
        };
      };
      launcher = {
        enableDangerousActions = false;
        showOnHover = false;
        useFuzzy = {
          actions = true;
          apps = true;
        };
        vimKeybinds = true;
      };
    };
    cli.enable = true; # Also add caelestia-cli to path
  };

  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${../scripts/xdg-termfilechooser.sh}
    default_dir=$HOME
  '';

  systemd.user = {
    enable = true;
    startServices = "sd-switch";
    services = {
      google-chrome = {
        Unit = {
          Description = "Google Chrome browser";
          Documentation = "https://www.google.com/chrome/";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = ''${pkgs.google-chrome}/bin/google-chrome-stable --enable-features=TouchpadOverscrollHistoryNavigation'';
          Restart = "on-failure";
          Slice = "session.slice";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };
      xdg-desktop-portal-termfilechooser = {
        Unit = {
          Description = "Portal service (terminal file chooser implementation)";
          PartOf = "graphical-session.target";
          After = "graphical-session.target";
        };
        Service = {
          Type = "dbus";
          BusName = "org.freedesktop.impl.portal.desktop.termfilechooser";
          ExecStart = "${pkgs.xdg-desktop-portal-termfilechooser}/libexec/xdg-desktop-portal-termfilechooser";
          Restart = "on-failure";
        };
      };
    };
  };

  services.playerctld.enable = true;

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    cursorTheme = {
      name = "Nordzy-cursors";
      size = 24;
    };
  };
  qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme.name = "adwaita";
  };
}
