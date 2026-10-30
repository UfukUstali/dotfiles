# Hyprland compositor + SDDM display manager.
{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.displayManager = {
    defaultSession = "hyprland-uwsm";
    sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
    };
    autoLogin = {
      enable = true;
      user = "ufuk";
    };
  };
}
