{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    google-chrome.url = "github:nixos/nixpkgs/nixos-unstable";
    ollama.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprland.url = "github:hyprwm/Hyprland";
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-dynamic-cursors = {
        url = "github:UfukUstali/hypr-dynamic-cursors";
        inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, hyprland, hy3, hypr-dynamic-cursors, google-chrome, ollama, ... }@inputs:
    let
      system = "x86_64-linux";
      chromePkgs = import google-chrome { inherit system; config.allowUnfree = true; };
      ollamaPkgs = import ollama { inherit system; config.allowUnfree = true; };
    in {
      nixosConfigurations = {
        ufuk-desktop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs system chromePkgs ollamaPkgs;
            hyprlandPkgs = hyprland.packages.${system};
          };
          modules = [
            ./configuration.nix
            ./hypr/sys.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs system chromePkgs ollamaPkgs;
                  hyprlandPkgs = hyprland.packages.${system};
                  hy3Pkgs = hy3.packages.${system};
                  hyprDyCursorsPkgs = hypr-dynamic-cursors.packages.${system};
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
