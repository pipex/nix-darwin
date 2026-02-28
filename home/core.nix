{ pkgs, ... }: {
  home.packages = with pkgs; [
    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    coreutils
    ripgrep
    jq
    yq-go
    gnugrep
    aria2
    socat
    nmap
    curl

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    gdu
    mosh
    libiconv
    colordiff

    # productivity
    glow # markdown previewer in terminal
    tmux

    git-crypt
    htop
    lazygit
    bottom

    (pkgs.ruby.withPackages (ps: with ps; [
      doing
    ]))

    (callPackage ../pkgs/balena-cli.nix {
      version = "22.4.5";
      hash = "11y9zjy6jv1411mpkxggj2hnq82kcxlf41np3vc8i4s110qjlsw9";
    })

    # Programming
    nodejs_22
    bun
    shellcheck
    shfmt
    rustup
    alejandra
    deadnix
    statix
    go
    hadolint
    luarocks
    nixd
    protobuf

    # Docker VM and CLI
    colima
    docker
    kubectl
    k9s

    unstable.qemu
  ];

  # Use the unstable neovim build on darwin
  programs.neovim.package = pkgs.unstable.neovim-unwrapped;

  # Ghostty
  home.file."Library/Application Support/com.mitchellh.ghostty/config".source = ../dotfiles/ghostty-config;

  # Prettier
  home.file.".prettierrc.json".source = ../dotfiles/prettierrc.json;

  # Global CLAUDE.md and settings
  home.file.".claude/CLAUDE.md".source = ../dotfiles/CLAUDE.md;
  home.file.".claude/settings.json".source = ../dotfiles/claude-settings.json;
}
