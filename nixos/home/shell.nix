{ ... }: {
  programs.zsh.profileExtra = ''
    export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.npm/bin:$HOME/.cargo/bin"
  '';
}
