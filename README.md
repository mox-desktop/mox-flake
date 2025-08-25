# Mox Desktop Components

A central Nix flake repository that aggregates all Mox desktop components and automatically updates when dependencies change.

## Overview

This repository serves as a unified collection point for the Mox desktop ecosystem, providing easy access to all Mox components through a single flake. It automatically tracks updates from individual component repositories and maintains synchronized versions.

## Usage

### Using the Overlay

Add the overlay to your Nix configuration to access all Mox packages:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mox-flake.url = "github:mox-desktop/mox-flake";
  };

  outputs = { nixpkgs, mox, ... }: {
    nixosConfigurations.yourHost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          nixpkgs.overlays = [ mox-flake.overlays.default ];
          environment.systemPackages = [
            pkgs.moxctl
            pkgs.moxnotify
            pkgs.moxidle
            pkgs.moxpaper
          ];
        }
      ];
    };
  };
}
```

### Using Home Manager Modules

The flake provides Home Manager modules for each component:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    mox.url = "github:your-username/your-repo-name";
  };

  outputs = { nixpkgs, home-manager, mox, ... }: {
    homeConfigurations.yourUser = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        mox.homeManagerModules.moxnotify
        mox.homeManagerModules.moxpaper
        mox.homeManagerModules.moxidle
        mox.homeManagerModules.moxctl
        {
          # Configure modules here
          programs.moxctl.enable = true;
          services.moxnotify.enable = true;
          # ... other configurations
        }
      ];
    };
  };
}
```

### Direct Package Access

You can also use packages directly without the overlay:

```bash
nix run github:mox-desktop/mox-flake#moxctl
nix shell github:mox-desktop/mox-flake#moxnotify
```

## Automatic Updates

This repository automatically updates its flake inputs when any of the component repositories are updated:

- **Trigger**: Repository dispatch events from component repositories
- **Schedule**: Manual workflow dispatch available
- **Process**: Updates `flake.lock` and commits changes automatically

## License

Please refer to individual component repositories for their respective licenses.
