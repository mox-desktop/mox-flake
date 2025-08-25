{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) types;
  cfg = config.environment.mox;
in
{
  options.environment.mox = {
    enable = lib.mkEnableOption "mox desktop environment";
    ctl = {
      enable = lib.mkOption {
        type = types.bool;
        default = cfg.enable;
      };
      package = lib.mkPackageOption pkgs "moxctl" { };
    };
    idle = {
      enable = lib.mkOption {
        type = types.bool;
        default = cfg.enable;
      };
      package = lib.mkPackageOption pkgs "moxidle" { };
    };
    paper = {
      enable = lib.mkOption {
        type = types.bool;
        default = cfg.enable;
      };
      package = lib.mkPackageOption pkgs "moxpaper" { };
    };
    notify = {
      enable = lib.mkOption {
        type = types.bool;
        default = cfg.enable;
      };
      package = lib.mkPackageOption pkgs "moxnotify" { };
    };
  };
}
