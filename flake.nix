{
  description = "nix-on-droid config for the phone, sharing its shell setup with viicslen-nix/nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Its nixpkgs-for-bootstrap pin is deliberate upstream: it builds proot.
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # The shell modules, shared with viicslen-nix/nixos.
    home = {
      url = "github:viicslen-nix/home";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = let
        inherit (nixpkgs) lib;
        isModule = name: type: type == "regular" && lib.hasSuffix ".nix" name;
      in
        map (name: ./parts/${name}) (lib.attrNames (lib.filterAttrs isModule (builtins.readDir ./parts)));
    };
}
