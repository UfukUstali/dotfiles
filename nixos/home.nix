{ lib, config, pkgs, hyprlandPkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ufuk";
  home.homeDirectory = "/home/ufuk";
  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # fonts and themes
    font-awesome
    nerd-fonts.caskaydia-mono
    nerd-fonts.caskaydia-cove
    nordzy-cursor-theme

    # better utils
    eza
    fzf
    bat
    ripgrep
    dust
    cloc
    jq

    rclone
    lazygit
    lazydocker
    btop
    radeontop
    bluetui
    calcure
    impala

    yazi
    ripdrag
    simple-mtpfs # for yazi

    rquickshare

    # common apps/utils
    legcord
    google-chrome
    vscode
    unzip
    remmina
    anydesk
    playerctl
    libreoffice-qt6-fresh
    weylus
    minio-client
    testdisk

    # thm vpn
    openconnect

    # other
    wev
    hw-probe

    # languages
    gcc
    pnpm
    fnm
    go
    rustc
    cargo

    # soon(TM)
    # scrcpy
    # gnome-network-displays
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    # ".config/nvim".source = dotfiles/nvim-config;
    # ".config/yazi".source = dotfiles/yazi;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ufuk/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [ "$HOME/.local/share/nvim/mason/bin" ];

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
    git = {
      enable = true;
      userName = "Ufuk Ustali";
      userEmail = "ustaliufuk73@gmail.com";
      aliases = {
        graph = "log --oneline --graph";
        undo = "!f() { git reset HEAD~\${1:-1}; }; f";
      };
      extraConfig = {
        pull.rebase = true;
        rerere.enabled = true;
        init.defaultBranch = "master";
      };
    };
  };

  services = {
    playerctld.enable = true;
  };

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    cursorTheme = {
      name = "Nordzy-cursors";
      size = 24;
    };
  };
  qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme.name = "adwaita";
  };
}
