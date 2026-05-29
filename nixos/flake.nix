{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland/v0.55.0";

    caelestia-shell = {
      url = "github:UfukUstali/caelestia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, hyprland, caelestia-shell, ... }@inputs:
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
                };
                users.ufuk = {
                  imports = [
                    ./home.nix
                    ./hypr/home.nix
                    caelestia-shell.homeManagerModules.default
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
