{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland?rev=5ee35f914f921e5696030698e74fb5566a804768";
    hy3 = {
      url = "github:outfoxxed/hy3?rev=a1f892fa218f6def606ccb1f81ddc2e57d0551b8"; # where {version} is the hyprland release version
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
