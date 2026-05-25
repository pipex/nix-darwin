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

      # safe-chain: wraps npm/yarn/pnpm/bun/pip/uv with supply-chain attack protection
      [ -f "$HOME/.cache/safe-chain/current/scripts/init-posix.sh" ] && source "$HOME/.cache/safe-chain/current/scripts/init-posix.sh"
    '';

    shellAliases = {
      balena-staging = "BALENARC_BALENA_URL=balena-staging.com BALENARC_DATA_DIRECTORY=~/.balenaStaging balena";
      balena-support = "BALENARC_DATA_DIRECTORY=~/.balenaSupport balena";
      git-list-untracked = "git fetch --prune && git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}'";
      git-remove-untracked = "git fetch --prune && git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d";
    };
  };
}
