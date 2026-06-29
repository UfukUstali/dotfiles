# Baseline configuration shared by every host (workstation or server).
{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  # Sensible defaults; individual hosts may override.
  time.timeZone = "Europe/Berlin";

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

  # Base user. Roles/hosts append the extra groups they create.
  users.users.ufuk = {
    isNormalUser = true;
    description = "Ufuk Ustali";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    file
    patchelf
    bash
    neovim
    wget
    gnumake
    cmake
    openssl
    usbutils
    unzip

    # better utils
    eza
    fzf
    bat
    ripgrep
    dust
    cloc
    jq
    ouch

    rclone
    lazygit
    lazydocker
    btop
    sysz

    yazi
  ];

  programs = {
    fish.enable = true;
    git = {
      enable = true;
      config.safe.directory = [
        "/home/ufuk/projects/personal/dotfiles"
      ];
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [ ];
    };
  };

  # Override per host to match the release of its first install.
  system.stateVersion = "24.11";
}
