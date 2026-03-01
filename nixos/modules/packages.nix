{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    material-design-icons
    font-awesome
    nerd-fonts.sauce-code-pro
  ];

  environment.systemPackages = with pkgs; [
    # ghostty terminfo (for SSH sessions from ghostty)
    ghostty.terminfo

    # archives
    zip
    xz
    unzip

    # utils
    ripgrep
    jq
    curl
    git

    # terminal multiplexer
    tmux

    # TUI tools
    lazygit
    bottom
    gdu

    # development
    rustup
    nodejs
    go

    # shell tools
    shellcheck
    shfmt
    qemu
  ];

  environment.variables = {
    EDITOR = "nvim";
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";
  };

  # Register zsh as a valid login shell (home-manager configures the rest)
  programs.zsh.enable = true;

  # podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
