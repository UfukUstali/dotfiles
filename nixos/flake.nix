{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:UfukUstali/caelestia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, caelestia-shell, ... }@inputs:
    let
      lib = nixpkgs.lib;

      # Home-manager module sets per role. Workstations get the full graphical
      # home; servers only get the portable CLI base.
      workstationHome = [
        ./home/base.nix
        ./home/desktop.nix
        ./home/hypr.nix
        caelestia-shell.homeManagerModules.default
      ];
      serverHome = [
        ./home/base.nix
      ];

      # mkHost builds a nixosSystem from a host directory under ./hosts.
      #   name   - directory name under ./hosts and the nixosConfigurations key
      #   system - target platform (default x86_64-linux)
      #   home   - list of home-manager modules imported for user `ufuk`
      mkHost = { name, system ? "x86_64-linux", home ? serverHome }:
        lib.nixosSystem {
          specialArgs = {
            inherit inputs system;
          };
          modules = [
            ./hosts/${name}
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs system; };
                users.ufuk.imports = home;
                backupFileExtension = "backup";
              };
            }
          ];
        };
    in {
      nixosConfigurations = {
        # Workstations
        ufuk-laptop = mkHost {
          name = "laptop";
          home = workstationHome;
        };
        ufuk-desktop = mkHost {
          name = "desktop";
          home = workstationHome;
        };

        # Hetzner VPS templates (clone a host dir + regenerate hardware config
        # for each real machine). Boot variant is selected per host.
        hetzner-uefi = mkHost {
          name = "hetzner-uefi";
          home = serverHome;
        };
        hetzner-legacy = mkHost {
          name = "hetzner-legacy";
          home = serverHome;
        };

        # Real Hetzner VPS (legacy/BIOS), reinstalled from Ubuntu.
        nar-eksisi = mkHost {
          name = "nar-eksisi";
          home = serverHome;
        };
      };
    };
}
