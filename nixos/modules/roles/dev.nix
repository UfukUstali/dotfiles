# Development machine role: the tooling my dev boxes get on top of the
# workstation profile. Anything here comes from a flake input rather than
# nixpkgs — plain packages belong in modules/core or home/desktop.nix.
{ inputs, pkgs, system, ... }:

{
  environment.systemPackages = with pkgs; [
    # https://github.com/UfukUstali/corral — runs dev processes side by side.
    inputs.corral.packages.${system}.default
    google-cloud-sdk
  ];
}
