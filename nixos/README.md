# NixOS configuration

Modular flake supporting multiple machines from shared building blocks.

## Layout

```
flake.nix              # defines every host via the mkHost helper
hosts/                 # one directory per machine
  laptop/              #   ufuk-laptop   (workstation, real hardware)
  desktop/             #   ufuk-desktop  (workstation, template)
  hetzner-uefi/        #   UEFI VPS      (server, template)
  hetzner-legacy/      #   BIOS VPS      (server, template)
  nar-eksisi/          #   nar-eksisi    (server, real Hetzner BIOS VPS)
modules/
  core/                # baseline for every host (nix, locale, user, base pkgs)
  boot/                # uefi.nix (systemd-boot) | legacy.nix (GRUB/BIOS)
  desktop/             # graphical workstation profile (hyprland, audio, GUI)
  roles/               # server.nix (headless: ssh, firewall)
  services/            # opt-in services: samba, unbound, tailscale, virtualisation
home/
  base.nix             # portable home (shell, git, CLI tools) — all hosts
  desktop.nix          # GUI apps, dev toolchains, theming — workstations
  hypr.nix             # hyprland user session services
scripts/               # helper scripts referenced from modules
```

Each host's `default.nix` composes a config by importing `modules/core`, a boot
variant, and either `modules/desktop` (workstation) or `modules/roles/server.nix`
(server), plus any `modules/services/*` it wants.

## Hosts

| Config           | Role        | Boot   |
| ---------------- | ----------- | ------ |
| `ufuk-laptop`    | workstation | UEFI   |
| `ufuk-desktop`   | workstation | UEFI   |
| `hetzner-uefi`   | server      | UEFI   |
| `hetzner-legacy` | server      | BIOS   |
| `nar-eksisi`     | server      | BIOS   |

## Adding a host

1. `cp -r hosts/<closest-template> hosts/<new>`
2. Set `networking.hostName` (and `boot.loader.grub.device` for legacy).
3. Replace `hardware-configuration.nix` with
   `nixos-generate-config --show-hardware-config`.
4. Register it in `flake.nix` under `nixosConfigurations` (pick `workstationHome`
   or `serverHome`).

## Usage

```sh
sudo nixos-rebuild switch --flake .#ufuk-laptop
nix flake check        # evaluate all hosts
```
