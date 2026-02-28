{ username, ... }: {
  imports = [
    ../../home/common/core.nix
    ../../home/common/shell.nix
    ../../home/git.nix
    ../../home/starship.nix
    ./shell.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
