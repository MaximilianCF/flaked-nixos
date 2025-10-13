# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a declarative NixOS configuration repository using Nix flakes with integrated Home Manager. The repository manages system configurations for multiple hosts (`tars`, `hal9000`) and provides a comprehensive personal computing environment with development tools, desktop environment, and modular package management.

## Common Commands

### System Management

- `sudo nixos-rebuild switch --flake .#tars` - Apply system configuration for tars host
- `sudo nixos-rebuild switch --flake .#hal9000` - Apply system configuration for hal9000 host
- `home-manager switch --flake .#max` - Apply Home Manager configuration for user max
- `nix flake update` - Update flake inputs to latest versions
- `./scripts/nixos-upgrade.sh` - Automated system update (updates flake.lock + rebuilds)
- `./scripts/nix-gc-safe.sh` - Safe garbage collection (removes builds older than 7 days)
- `./scripts/nix-hub.sh` - Interactive TUI for common Nix operations

### Development Environments

- `nix develop` - Enter the default development shell (defined in flake.nix)
- `nix develop ./shell/rust#` - Enter Rust development environment
- `nix develop ./shell/blog#` - Enter blog development environment
- `nix develop ./shell/infra#` - Enter infrastructure development environment
- `nix develop ./shell/ros2#` - Enter ROS2 development environment
- `./scripts/devshell-list.sh` - List all available development shells

### Code Quality & Formatting

- `nix fmt` - Format all Nix files using nixfmt
- `treefmt` - Format all files according to treefmt.nix configuration
- Pre-commit hooks automatically run `convco` (conventional commits) and `nixfmt-rfc-style`

### Testing & Validation

- `nix build .#nixosConfigurations.tars.config.system.build.toplevel` - Build system without switching
- `nix build .#homeConfigurations.max.activationPackage` - Build Home Manager config without switching

## Architecture

### Core Structure

- **flake.nix**: Root flake defining all system configurations, Home Manager setups, and development environments
- **hosts/**: Per-machine NixOS configurations (`tars/`, `hal9000/`)
- **home/**: Home Manager configuration with modular package management
- **modules/**: Reusable NixOS modules (postgres, distributed-builds)
- **shell/**: Development environment definitions for specific technologies
- **scripts/**: Automation scripts for common operations

### Key Design Patterns

**Modular Package Management**: Packages are organized by category in `home/pkgs/` (dev.nix, gnome.nix, media.nix, etc.) and imported into the main Home Manager configuration.

**Multi-Host Support**: The flake defines configurations for different machines with shared Home Manager configuration but host-specific system settings.

**Development Environment Isolation**: Each technology stack has its own development shell in `shell/` directory with specific tooling and dependencies.

**Brazilian Localization**: System is configured for Brazilian Portuguese locale (pt_BR.UTF-8) with ABNT2 keyboard layout.

### Important Configuration Details

**Nix Settings**:

- Flakes and nix-command experimental features enabled
- Multiple binary caches configured (nix-community.cachix.org, numtide.cachix.org)
- Automatic garbage collection runs weekly, keeping 7 days of builds

**Desktop Environment**:

- GNOME desktop with GDM display manager
- Auto-login enabled for user 'max'
- Flatpak support configured with Flathub repository

**Development Tools**:

- Multiple editors available: VSCode, Neovim, Emacs, Zed, Lapce
- Git tooling: gh, lazygit, git-secret, git-review
- Container tools: Docker, lazydocker
- Database: PostgreSQL module with custom configuration

**Home Manager Integration**:

- Backup file extension set to ".backup"
- Auto-upgrade enabled daily
- Profile sync daemon (PSD) configured for Chrome

### Module System

Custom modules in `modules/` extend functionality:

- `postgres.nix`: Configurable PostgreSQL service
- `distributed-builds.nix`: Remote build configuration support

Home Manager modules in `home/modules/` organize user environment:

- `editores/`: Text editor configurations
- `shell_terminal/`: Shell and terminal setup
- `system/`: System utilities and tools
- `misc/`: Miscellaneous applications

## Host-Specific Notes

**Tars Configuration**:

- Hostname: "Endurance"
- GRUB bootloader with EFI support
- Emulated system support for aarch64-linux
- Latest kernel packages
- Includes R/RStudio environment
- Docker virtualization enabled

**Development Shells**:

- Blog: Tools for static site generation and content management
- Rust: Complete Rust toolchain with cargo and utilities
- Infrastructure: Tools for infrastructure management and deployment
- ROS2: Robot Operating System 2 development environment

## Pre-commit Configuration

Automated code quality checks include:

- Conventional commit message validation (convco)
- Nix code formatting (nixfmt-rfc-style)
- Additional formatting via treefmt (markdown, YAML)
