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
        inherit (inputs.moxnotify.homeManagerModules) moxnotify;
        inherit (inputs.moxpaper.homeManagerModules) moxpaper;
        inherit (inputs.moxidle.homeManagerModules) moxidle;
        inherit (inputs.moxctl.homeManagerModules) moxctl;
      };

      overlays.default =
        final: prev:
        let
          inherit (prev) system;
        in
        {
          inherit (inputs.moxctl.packages.${system}) moxctl;
          inherit (inputs.moxnotify.packages.${system}) moxnotify;
          inherit (inputs.moxidle.packages.${system}) moxidle;
          inherit (inputs.moxpaper.packages.${system}) moxpaper;
        };
    };
}
