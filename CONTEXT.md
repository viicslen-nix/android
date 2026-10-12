# CONTEXT

## Why this isn't part of viicslen-nix/nixos

It lives as a submodule at `/etc/nixos/flakes/android` but is deliberately not
an input of that flake, and does not take it as an input either. The phone
clones and evaluates this repo by itself, and pulling in the NixOS flake would
mean ~200 lock nodes, of which it uses only the shell config. That shared part
was extracted to `viicslen-nix/home`, which both repos consume, so the two
cannot drift.

## Channel

nixos-unstable plus nix-on-droid `master`. nix-on-droid's last release branch
is 24.05, but `master` is maintained and tracks nixpkgs and home-manager
master, so unstable matches it better than a frozen release.
`nixpkgs-for-bootstrap` stays on nix-on-droid's own pin: it builds proot, and
upstream updates the store paths by hand when they move it.

## `home-manager.config = {}`

nix-on-droid wraps its whole home-manager integration in
`mkIf (cfg.config != null)`. The config here lives in `sharedModules` (preset
and host `home.nix`, like the NixOS repo), so `config` only has to be non-null.

## What the phone turns off

- `jujutsu.meld`: a GTK app, and there is no display.
- `shellProfile.signingKey = null`: the private key isn't on the phone. With
  jj's `signing.behavior = "own"` and no key, every commit would fail.
- `nushell.enableContainerIntegration`: there is no docker or podman.

## Build cost

`jj-starship` (from the starship module) and `hunk` are built from flakes, not
nixpkgs, so cache.nixos.org doesn't have them and the first switch compiles
both on the phone: a Rust crate and a bun2nix build.
