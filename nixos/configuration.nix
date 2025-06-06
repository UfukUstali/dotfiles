#Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hyprlandPkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "i2c-dev" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Virtualisation
  virtualisation = {
    # waydroid.enable = true;
    docker.enable = true;
    spiceUSBRedirection.enable = true;
  };

  # Enable networking
  networking = {
    hostName = "ufuk-laptop"; # Define your hostname.
    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          EnableNetworkConfiguration = true;
        };
        IPv6 = {
          Enabled = true;
        };
        Scan = {
          DisablePeriodicScan = true;
        };
        Settings = {
          AutoConnect = true;
        };
      };
    };
    nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 33611 3000 ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
      options = "compose:ralt,caps:swapescape";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    groups = {
      uinput = {};
    };
    users = {
      ufuk = {
        isNormalUser = true;
        description = "Ufuk Ustali";
        extraGroups = [ "networkmanager" "wheel" "ydotool" "i2c" "uinput" "docker" ];
        packages = with pkgs; [ ];
        shell = pkgs.fish;
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    file
    patchelf
    bash
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    gnumake
    cmake
    wl-clipboard
    brightnessctl
    ddcutil
    pavucontrol
    libnotify
    kitty
    wofi
    rofi-wayland
    libinput
    firefox
    bluez
    bluez-tools
    gnome-themes-extra
    home-manager
    openssl
    qemu
    quickemu
  ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  environment.variables = {
  };
  hardware = {
    graphics.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk hyprlandPkgs.xdg-desktop-portal-hyprland ];
  };

  # List services that you want to enable:
  security.rtkit.enable = true;
  services = {

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    logind = {
      lidSwitch = "suspend";
      lidSwitchDocked = "suspend";
      lidSwitchExternalPower = "suspend";
    };

    # 1-2 for ddcutil
    # 3 for weylus
    udev.extraRules = ''
      SUBSYSTEM=="i2c-dev", KERNEL=="i2c-[0-9]*", ATTRS{class}=="0x030000", TAG+="uaccess"
      SUBSYSTEM=="dri", KERNEL=="card[0-9]*", TAG+="uaccess"

      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';

    resolved = {
      enable = true;
      dnsovertls = "opportunistic";
      domains = [ "~." ];
      fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    };

    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "ufuk-laptop";
          "netbios name" = "ufuk-laptop";
          "security" = "user";
          "server signing" = "mandatory";
          "client signing" = "mandatory";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.2. 127.0.0.1 localhost";
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

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    # for network device discovery
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 85;
      };
    };

    # gvfs.enable = true;
    printing.enable = true;
    libinput.enable = true;
    tailscale.enable = true;
    upower.enable = true;
    flatpak.enable = true;
  };

  programs = {
    ydotool.enable = true;
    fish.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        fnm
      ];
    };
  };

  environment.etc."dconf/db/local.d/00-settings".text = ''
    [org/gnome/desktop/interface]
    color-scheme='prefer-dark'
  '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
