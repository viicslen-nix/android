# nix-on-droid configurations for every host in hosts/default.nix.
{
  inputs,
  lib,
  ...
}: let
  hostsPath = ../hosts;
  inherit (import hostsPath {}) hosts;

  mkHost = hostName: hostConfig: let
    hostPath = hostsPath + "/${hostName}";
    hostHome = hostPath + "/home.nix";
  in
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import inputs.nixpkgs {
        system = hostConfig.system or "aarch64-linux";
        overlays = [inputs.nix-on-droid.overlays.default];
      };

      modules =
        map (name: ../presets/${name}) (hostConfig.presets or [])
        ++ [hostPath]
        ++ lib.optional (builtins.pathExists hostHome) {
          _file = hostPath;
          home-manager.sharedModules = [hostHome];
        };

      extraSpecialArgs = {inherit inputs hostName;};
      home-manager-path = inputs.home-manager.outPath;
    };
in {
  flake.nixOnDroidConfigurations = lib.mapAttrs mkHost hosts;
}
