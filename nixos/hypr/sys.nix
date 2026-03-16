{ inputs, pkgs, ...}: {
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    hyprlock.enable = true;
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
