{
  inputs = {
    moxidle.url = "github:mox-desktop/moxidle";
    moxnotify.url = "github:mox-desktop/moxnotify";
    moxctl.url = "github:mox-desktop/moxctl";
    moxpaper.url = "github:mox-desktop/moxpaper";
  };
  outputs =
    {
      moxnotify,
      moxpaper,
      moxidle,
      moxctl,
      ...
    }:
    {
      homeManagerModules = {
        inherit (moxnotify.homeManagerModules) moxnotify;
        inherit (moxpaper.homeManagerModules) moxpaper;
        inherit (moxidle.homeManagerModules) moxidle;
        inherit (moxctl.homeManagerModules) moxctl;
      };

      overlays.default =
        final: prev:
        let
          inherit (prev.stdenv.hostPlatform) system;
        in
        {
          inherit (moxctl.packages.${system}) moxctl;
          inherit (moxnotify.packages.${system}) moxnotify;
          inherit (moxidle.packages.${system}) moxidle;
          inherit (moxpaper.packages.${system}) moxpaper;
        };
    };
}
