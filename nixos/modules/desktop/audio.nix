# PipeWire audio stack.
{ pkgs, ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  # JACK apps: run them through `pw-jack <app>` instead of the deprecated
  # global `services.pipewire.jack.enable`.
  environment.systemPackages = [ pkgs.pipewire.jack ];
}
