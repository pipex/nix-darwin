{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = false;

    zprof.enable = false;

    oh-my-zsh = {
      enable = true;
      custom = "${config.xdg.configHome}/oh-my-zsh";
      extraConfig = ''
        DISABLE_MAGIC_FUNCTIONS="true";
      '';
    };

    shellAliases = {
      vi = "nvim";
      lg = "lazygit";
      cd = "z";
    };

    localVariables = {
      TZ = "America/Santiago";
      EDITOR = "nvim";
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  };
}
