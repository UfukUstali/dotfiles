{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-dynamic-cursors = {
        url = "github:VirtCode/hypr-dynamic-cursors";
        inputs.hyprland.follows = "hyprland";
    };
    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, hyprland, hy3, hypr-dynamic-cursors, hyprspace, ... }@inputs:
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
                  hyprDyCursorsPkgs = hypr-dynamic-cursors.packages.${system};
                  hyprspacePkgs = hyprspace.packages.${system};
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
