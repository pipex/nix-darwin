{ pkgs, ... }:
{
  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  # TODO Fell free to modify this file to fit your needs.
  #
  ##########################################################################

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    neovim
    git
    just # use Justfile to simplify nix-darwin's commands
  ];
  environment.variables.EDITOR = "nvim";

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = true; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    masApps = {
      # TODO Feel free to add your favorite apps here.

      Xcode = 497799835;
      Bitwarden = 1352778147;
      Magnet = 441258766;
      JoltOfCaffeine = 1437130425;
      DuckDuckGoSafari = 1482920575;
    };

    taps = [
      "homebrew/services"
    ];

    # `brew install`
    brews = [
      "httpie" # http client
      "diffutils" # diff tool
      "mas" # Mac App Store CLI
      "podman"
      "pinentry-mac"
      "ykman"
    ];

    # `brew install --cask`
    casks = [
      "balenaetcher"
      "cloudflare-warp"
      "docker"
      "ungoogled-chromium"
      "raycast"
      "signal"
      "tailscale"
      "zoom"
      "appcleaner"
      "iterm2"
      "wireshark-app"
      {
        name = "librewolf"; 
        args = { no_quarantine = true; };
      }
    ];
  };
}
