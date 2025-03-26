{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    coreutils # GNU core utilities
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    gnugrep # GNU grep, egrep and fgrep

    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
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

    # We need to use unstable tmux because of
    # https://github.com/tmux/tmux/issues/3983
    unstable.tmux

    git-crypt # transparent file encryption in git
    htop # interactive process viewer

    lazygit # Git TUI

    (callPackage ../pkgs/balena-cli.nix {
      version = "20.0.7";
      hash = "0hw9k006jzf26f9kv346g1sn3s0rjz1k692n1114nqqlh0jsqx80";
    })

    # (pkgs.callPackage ../pkgs/shell-gpt.nix {
    #   version = "1.4.3";
    #   hash = "1ip4216ypjk8p0p69frg006gnl571gfarc6irl63hsln3cmxjz2a";
    # })
    bottom # process viewer
    gdu # go disk analyzer

    # Programming
    nodejs_22 # A JavaScript runtime built on Chrome's V8 JavaScript engine
    bun
    shellcheck # shell script analysis tool
    shfmt # A shell parser, formatter, and interpreter (POSIX/Bash/mksh)
    rustup # Rust updater
    alejandra # The Uncompromising Nix Code Formatter
    deadnix # Nix
    statix # Nix
    go # Golang
    hadolint # Dockerfile linter, validate inline bash scripts
    luarocks # Lua linter
    nixd

    # Docker VM and CLI
    colima
    docker
    kubectl

    unstable.qemu
  ];

  # Install AstroVim
  xdg.configFile."nvim".recursive = true;
  xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
    owner = "pipex";
    repo = "astrovim";
    rev = "9d654e8";
    sha256 = "1rymmb3ag0ikv0jyx6akdvfyrhvlg2npv52c46hxzfs6b9n8sz6i";
  };
  # xdg.configFile."nvim".source = ../dotfiles/astronvim;

  xdg.configFile."oh-my-zsh".source = ../dotfiles/oh-my-zsh;

  home.file.".tmux.conf".source = ../dotfiles/tmux/tmux.conf;
  home.file.".tmux".recursive = true;
  home.file.".tmux".source = ../dotfiles/tmux;
  home.file.".tmux/plugins/tpm".source = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tpm";
    rev = "v3.0.0";
    sha256 = "18q5j92fzmxwg8g9mzgdi5klfzcz0z01gr8q2y9hi4h4n864r059";
  };

  # Prettier
  home.file.".prettierrc.json".source = ../dotfiles/prettierrc.json;

  # Avoid bugs with npm like https://github.com/NixOS/nixpkgs/issues/16441
  home.file.".npmrc".text = lib.generators.toINIWithGlobalSection {} {
    globalSection = {
      prefix = "~/.npm";
    };
  };

  programs = {
    # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      package = pkgs.unstable.neovim-unwrapped;
    };

    # A modern replacement for ‘ls’
    # useful in bash/zsh prompt, not in nushell.
    eza = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      git = true;
      icons = "auto";
    };

    # skim provides a single executable: sk.
    # Basically anywhere you would want to use grep, try sk instead.
    skim = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    gh = {
      enable = true;
      settings.git_protocol = "ssh";
      gitCredentialHelper.enable = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    gpg = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
