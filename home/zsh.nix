{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    autocd = true;

    # # https://checkoway.net/musings/nix/
    # envExtra = ''
    #   [[ -o login ]] && export PATH='/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin'
    # '';

    # https://checkoway.net/musings/nix/
    profileExtra = ''
      # Set PATH, MANPATH, etc., for Homebrew.
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    initExtra = ''
      export BALENARC_NO_ANALYTICS=1
      export BUILDKIT_PROGRESS=plain

      cb() {
        if [ -d .git ]; then
          ([ "$GIT_REPO_HOME" = "" ] || [ ! -d "$GIT_REPO_HOME" ]) && echo "Already in a git repository and not GIT_REPO_HOME defined" && return 1
          cd $GIT_REPO_HOME
        fi

        repo="$GIT_REPO"
        folder="$1"
        branch="$1"

        [ "$repo" = "" ] && echo "No GIT_REPO environment variable" && return 1

        if [ "$folder" = "" ]; then
          branch="$(git ls-remote --symref "git@github.com:$repo.git" HEAD | awk '/^ref:/ {sub(/refs\/heads\//, "", $2); print $2}')"
          folder="$branch"
        fi

        if [ -d "$folder" ]; then
          cd "$folder"
          [ ! -d ".git" ] && echo "Folder $folder exists but is not a git repository" && return 1
          return 0
        fi

        git clone --recurse-submodules "git@github.com:$repo.git" $folder && \
          cd $folder && \
          (git checkout $branch || git checkout -b $branch)

        if [ -f "package-lock.json" ]; then
          npm ci
        elif [ -f "package.json" ]; then
          npm i
        fi
      }
    '';

    oh-my-zsh = {
      enable = true;
      plugins = ["git docker"];
      custom = "${config.xdg.configHome}/oh-my-zsh";
      theme = "pipex";
      extraConfig = ''
        DISABLE_MAGIC_FUNCTIONS="true";
      '';
    };

    shellAliases = {
      balena-support = "BALENARC_DATA_DIRECTORY=~/.balenaSupport balena";
      vi = "nvim";
      lg = "lazygit";
      cd = "z";
    };

    localVariables = {
      TZ = "America/Santiago";
      EDITOR = "nvim";
      BALENARC_NO_ANALYTICS = "1";
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
