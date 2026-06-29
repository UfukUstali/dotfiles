# Portable home configuration: shell, git and CLI tooling. Imported by every
# host (workstation and server).
{ pkgs, ... }:

{
  home.username = "ufuk";
  home.homeDirectory = "/home/ufuk";
  nixpkgs.config.allowUnfree = true;

  # Don't change without reading the Home Manager release notes.
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    go-passbolt-cli
    turbo

    # languages
    gcc
    go
  ];

  home.sessionVariables.EDITOR = "nvim";
  home.sessionPath = [ "$HOME/.local/share/nvim/mason/bin" ];

  programs = {
    home-manager.enable = true;

    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "Ufuk Ustali";
          email = "ustaliufuk73@gmail.com";
        };

        alias = {
          graph = "log --oneline --graph";
          undo = "!f() { git reset HEAD~\${1:-1}; }; f";
        };

        pull.rebase = true;
        rerere.enabled = true;
        rebase.updateRefs = true;
        init.defaultBranch = "master";
      };
    };
  };
}
