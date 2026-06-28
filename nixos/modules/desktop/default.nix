# Graphical workstation profile: compositor, audio, GUI hardware, portals and
# the desktop apps shared by the laptop and desktop hosts.
{ pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./audio.nix
  ];

  # Workstation networking: NetworkManager + nftables firewall.
  networking = {
    networkmanager.enable = true;
    nftables.enable = true;
    firewall.enable = true;
  };

  # Keyboard layout (compose key on right alt, escape/caps swapped).
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "compose:ralt,caps:swapescape";
  };

  # Graphical-capable hardware.
  hardware = {
    i2c.enable = true;
    graphics.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Extra groups for the graphical session (these groups are created by the
  # options enabled in this profile).
  users.groups.uinput = { };
  users.users.ufuk.extraGroups = [
    "networkmanager"
    "i2c"
    "uinput"
    "ydotool"
    "wireshark"
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    wl-clipboard
    brightnessctl
    ddcutil
    pavucontrol
    libnotify
    firefox
    bluez
    bluez-tools
    gnome-themes-extra
    home-manager
    android-tools
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-termfilechooser
    ];
    config.hyprland = {
      default = [ "hyprland" "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
    };
  };

  programs = {
    wireshark = {
      enable = true;
      usbmon.enable = true;
    };
  };

  services = {
    # Network device discovery (mDNS).
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing.enable = true;
    libinput.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    flatpak.enable = true;
  };

  # Prefer dark theme for GTK apps via dconf.
  environment.etc."dconf/db/local.d/00-settings".text = ''
    [org/gnome/desktop/interface]
    color-scheme='prefer-dark'
  '';
}
