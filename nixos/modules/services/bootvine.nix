# bootvine — live tree of systemd jobs on the boot/shutdown console.
# Mirrors upstream's nix/nixos-module.nix, but uses the cached nixpkgs binary
# instead of the bootvine flake's own build. The nixpkgs package ships only the
# binary, so the systemd units are copied from its source here.
{ lib, pkgs, ... }:

let
  bin = lib.getExe pkgs.bootvine;

  units = pkgs.runCommand "bootvine-units-${pkgs.bootvine.version}" { } ''
    files=${pkgs.bootvine.src}/bootvine/system-files/systemd
    for unit in bootvine.service bootvine-shutdown.service \
                systemd-hibernate-resume.service.d/bootvine.conf; do
      install -Dm644 $files/$unit $out/lib/systemd/system/$unit
      substituteInPlace $out/lib/systemd/system/$unit \
        --replace-fail /usr/bin/bootvine ${bin}
    done
  '';
in
{
  environment.systemPackages = [ pkgs.bootvine ];

  systemd = {
    packages = [ units ];
    services.bootvine.wantedBy = [ "sysinit.target" ];
    services.bootvine-shutdown.wantedBy = [ "shutdown.target" ];
  };

  boot.initrd.systemd = {
    packages = [ units ];
    storePaths = [ bin ];
    services.bootvine.wantedBy = [ "sysinit.target" ];
  };
}
