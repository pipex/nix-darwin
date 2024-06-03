{
  pkgs,
  config,
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
    reattach-to-user-namespace # For tmux copy/paste
    libiconv
    colordiff

    # productivity
    glow # markdown previewer in terminal
    tmux

    git-crypt # transparent file encryption in git
    htop # interactive process viewer

    bitwarden-cli # The command line vault (Windows, macOS, & Linux).
    lazygit # Git TUI

    (callPackage ../pkgs/balena-cli.nix {
      version = "18.1.0";
      hash = "sha256-/Kvp81qOYzpTkWECePg+MM7EW4FxqEKqimdVqPlyAsE=";
    })

    (pkgs.callPackage ../pkgs/shell-gpt.nix {
      version = "1.4.3";
      hash = "1ip4216ypjk8p0p69frg006gnl571gfarc6irl63hsln3cmxjz2a";
    })

    # Programming
    nodejs_20 # A JavaScript runtime built on Chrome's V8 JavaScript engine
    shellcheck # shell script analysis tool
    shfmt # A shell parser, formatter, and interpreter (POSIX/Bash/mksh)
    rustup # Rust updater
    alejandra # The Uncompromising Nix Code Formatter
    deadnix # Nix
    statix # Nix
    go # Golang
    hadolint # Dockerfile linter, validate inline bash scripts
    luarocks # Lua linter
  ];

  # Install AstroVim
  xdg.configFile."nvim".recursive = true;
  xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
    owner = "pipex";
    repo = "astrovim";
    rev = "ffbb732dd70987daa0c71c39c3f32585e52f5fdc";
    sha256 = "0bgkwyz02h8vdlkifziay9fgbl025jl5svzgfsps6jgy0ack8yyl";
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

  programs = {
    # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    # A modern replacement for ‘ls’
    # useful in bash/zsh prompt, not in nushell.
    eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
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

    autojump = {
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
