{ pkgs, lib, config, ... }: {
  # AstroVim
  xdg.configFile."nvim".recursive = true;
  xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
    owner = "pipex";
    repo = "astrovim";
    rev = "91ba341";
    sha256 = "03g7l071cw344hcjw613hb1x4y4wysbx82l3fd0i1n925i43xpid";
  };

  xdg.configFile."oh-my-zsh".source = ../../dotfiles/oh-my-zsh;

  home.file.".tmux.conf".source = ../../dotfiles/tmux/tmux.conf;
  home.file.".tmux".recursive = true;
  home.file.".tmux".source = ../../dotfiles/tmux;
  home.file.".tmux/plugins/tpm".source = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tpm";
    rev = "v3.0.0";
    sha256 = "18q5j92fzmxwg8g9mzgdi5klfzcz0z01gr8q2y9hi4h4n864r059";
  };

  home.file.".npmrc".text = lib.generators.toINIWithGlobalSection {} {
    globalSection = {
      prefix = "~/.npm";
    };
  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      git = true;
      icons = "auto";
    };

    skim = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    gpg.enable = true;

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    gh = {
      enable = true;
      settings.git_protocol = "ssh";
      gitCredentialHelper.enable = true;
    };
  };
}
