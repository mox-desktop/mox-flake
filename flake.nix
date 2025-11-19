{
  inputs = {
    moxidle.url = "git+https://forgejo.r0chd.pl/mox-desktop/moxidle.git";
    moxnotify.url = "git+https://forgejo.r0chd.pl/mox-desktop/moxnotify.git";
    moxctl.url = "git+https://forgejo.r0chd.pl/mox-desktop/moxctl.git";
    moxpaper.url = "git+https://forgejo.r0chd.pl/mox-desktop/moxpaper.git";
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
