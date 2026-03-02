{
  description = "Nix for macOS configuration";

  ##################################################################################################################
  #
  # Want to know Nix in details? Looking for a beginner-friendly tutorial?
  # Check out https://github.com/ryan4yin/nixos-and-flakes-book !
  #
  ##################################################################################################################

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
    ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-darwin,
    nixpkgs-unstable,
    darwin,
    home-manager,
    ...
  }: let
    # Shared identity
    fullname = "Felipe Lalanne";
    username = "felipe";
    useremail = "felipe@balena.io";

    # Darwin config
    system = "aarch64-darwin"; # aarch64-darwin or x86_64-darwin
    hostname = "ceres";

    specialArgs =
      inputs
      // {
        inherit username useremail hostname fullname;
      };

    # SSH public keys shared across all NixOS servers (password auth is disabled)
    sshKeys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBChyWFF1BmSdrvKR/ExZtQVfxvCwauWB/5E7vD2Fu0G3PN9ud4DK02RFMKGe43bjIzQUzXsv3+b1Vv1YypPiDOE= felipe@ipad"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIESnsaukXTbFf2xLENvpTFwS/zSk8jNMshUYW+pWz1BQ felipe@balena.io"
    ];

    mkNixosConfig = { hostname, system }: let
      specialArgs = inputs // { inherit fullname username useremail hostname sshKeys; };
    in nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        ./nixos/modules/system.nix
        ./nixos/modules/nix-core.nix
        ./nixos/modules/users.nix
        ./nixos/modules/packages.nix
        ./nixos/modules/ssh.nix
        ./nixos/modules/tailscale.nix
        ./nixos/hosts/${hostname}/hardware-configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.${username} = import ./nixos/home;
        }
      ];
    };
  in {
    darwinConfigurations."${hostname}" = darwin.lib.darwinSystem {
      inherit system specialArgs;
      modules = [
        ./modules/nix-core.nix
        ./modules/system.nix
        ./modules/apps.nix
        ./modules/host-users.nix

        # Allow use of pkgs.unstable in modules
        ({...}: {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
              };
            })
          ];
        })
        # home manager
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.${username} = import ./home;
        }
      ];
    };

    nixosConfigurations = {
      phobos = mkNixosConfig { hostname = "phobos"; system = "x86_64-linux"; };
      deimos = mkNixosConfig { hostname = "deimos"; system = "aarch64-linux"; };
    };

    # nix code formatters
    formatter.aarch64-darwin = nixpkgs-darwin.legacyPackages.aarch64-darwin.alejandra;
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.alejandra;
  };
}
