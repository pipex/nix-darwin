{ pkgs, config, ... }: {
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
      version = "24.0.3";
      hash = "1w6rma90w8yl9l88dgb2barkasjvrl8m69lgsanbl4wym6hqmr96";
    })

    (callPackage ../pkgs/safe-chain.nix {})

    # Programming
    nodejs_24
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

  # Safe-chain config
  home.file.".safe-chain/config.json".source = ../dotfiles/safe-chain-config.json;

  home.activation.safe-chain-setup = config.lib.dag.entryAfter ["writeBoundary"] ''
    if command -v safe-chain &> /dev/null; then
      run safe-chain setup 2>/dev/null || true
    fi
  '';
}
