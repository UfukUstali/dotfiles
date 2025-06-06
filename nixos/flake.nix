{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland?rev=2794f485cb5d52b3ff572953ddcfaf7fd3c25182";
    hy3 = {
      url = "github:outfoxxed/hy3?rev=567dc9dd20e15d95a56a81c516a70dba30bc2c9c"; # where {version} is the hyprland release version
      # or "github:outfoxxed/hy3" to follow the development branch.
      # (you may encounter issues if you dont do the same for hyprland)
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, hyprland, hy3, ... }@inputs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        ufuk-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs system;
            hyprlandPkgs = hyprland.packages.${system};
          };
          modules = [
            ./configuration.nix
            ./hypr/sys.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs system;
                  hyprlandPkgs = hyprland.packages.${system};
                  hy3Pkgs = hy3.packages.${system};
                };
                users.ufuk = {
                  imports = [
                    ./home.nix
                    ./hypr/home.nix
                  ];
                };
                backupFileExtension = "backup";
              };
            }
          ];
        };
      };
    };
}
