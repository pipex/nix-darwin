{ ... }: {
  programs.zsh = {
    oh-my-zsh.plugins = [ "docker" ];

    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.npm/bin:$HOME/.cargo/bin"
    '';

    initContent = ''
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

    shellAliases = {
      balena-staging = "BALENARC_BALENA_URL=balena-staging.com BALENARC_DATA_DIRECTORY=~/.balenaStaging balena";
      balena-support = "BALENARC_DATA_DIRECTORY=~/.balenaSupport balena";
    };
  };
}
