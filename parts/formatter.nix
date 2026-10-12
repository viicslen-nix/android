{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    treefmt.imports = [../treefmt.nix];

    # Catches the repeated keys `statix fix` leaves alone.
    checks.statix = pkgs.runCommandLocal "statix-check" {} ''
      ${lib.getExe pkgs.statix} check ${../.} && touch $out
    '';
  };
}
