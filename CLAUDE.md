# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Repository

This is a nix-darwin configuration for macOS that manages system packages, applications, and user dotfiles. The configuration is based on the nix-darwin-kickstarter template and is customized for a specific user setup.

## Common Commands

### Build and Deploy
- `make deploy` or `make darwin` - Build and apply the nix-darwin configuration
- `make darwin-debug` - Build and apply with verbose debugging output

### Package Management
- `make update` - Update all flake inputs (equivalent to `nix flake update`)
- `make update-commit` - Update flake inputs and commit the lock file
- `make fmt` - Format all Nix files using alejandra formatter

### System Maintenance
- `make history` - Show system profile history
- `make gc` - Garbage collect old generations (7+ days) and unused store entries
- `make optimise` - Optimize the Nix store by hardlinking identical files
- `make clean` - Remove build result symlinks

## Architecture

### Configuration Structure
- `flake.nix` - Main entry point defining inputs (nixpkgs, home-manager, darwin) and system configuration
- `modules/` - System-level nix-darwin modules:
  - `apps.nix` - Package installations (nix packages + homebrew)
  - `system.nix` - macOS system settings (dock, trackpad, etc.)
  - `host-users.nix` - Hostname and user definitions
  - `nix-core.nix` - Core Nix configuration
- `home/` - Home Manager modules for user-level configuration:
  - `default.nix` - Entry point importing all home modules
  - `core.nix` - User packages (CLI tools, utilities)
  - Shell configurations: `bash.nix`, `zsh.nix`, `starship.nix`
  - `git.nix` - Git configuration
  - `secrets.nix` - Secret management via homeage

### Key Details
- Target system: `aarch64-darwin` (Apple Silicon Mac)
- Hostname: `ceres`
- Username: `felipe`
- Uses nixpkgs 24.11 stable with unstable overlay available as `pkgs.unstable`
- Combines nix-darwin (system) + home-manager (user) + homebrew (additional apps)
- Secret management handled by homeage module

### Package Management Strategy
- System packages in `modules/apps.nix` via `environment.systemPackages`
- User packages in `home/core.nix` via `home.packages`
- GUI applications primarily via homebrew in `modules/apps.nix`
- Mac App Store apps via `masApps` (requires manual initial install)

## Development Workflow

When modifying configurations:
1. Edit the relevant `.nix` files
2. Run `make fmt` to format code
3. Test with `make darwin` or use `make darwin-debug` if issues arise
4. Use `make clean` to remove build artifacts if needed