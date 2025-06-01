{ pkgs, hyprlandPkgs, ...}: {

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      package = hyprlandPkgs.hyprland;
      portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
    };
    hyprlock = {
      enable = true;
    };
  };

  services = {
    displayManager = {
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
  };
}
