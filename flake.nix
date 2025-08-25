{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    moxidle.url = "github:mox-desktop/moxidle";
    moxnotify.url = "github:mox-desktop/moxnotify";
    moxctl.url = "github:mox-desktop/moxctl";
    moxpaper.url = "github:mox-desktop/moxpaper";
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs systems (
          system:
          let
            pkgs = import nixpkgs { inherit system; };
          in
          function pkgs
        );

      overlays =
        final: prev:
        let
          inherit (prev) system;
        in
        {
          inherit (inputs.moxctl.packags.${system}) moxctl;
          moxnotify = inputs.moxnotify.packages.${system}.default;
          moxidle = inputs.moxidle.packages.${system}.default;
          moxpaper = inputs.moxpaper.packages.${system}.default;
        };
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          buildInputs = builtins.attrValues {
            inherit (pkgs)
              nixd
              nixfmt-rfc-style
              ;
          };
        };
      });

      homeManagerModules = {
        default = import ./nix/home-manager.nix;
      };

      overlay = overlays;
      overlays.default = overlays;
    };
}
