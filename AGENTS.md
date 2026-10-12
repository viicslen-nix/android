# AGENTS.md

Rules for agents editing this repo. The reasoning is in `CONTEXT.md`.

- **Keep it lean.** Don't add `viicslen-nix/nixos`, nixvim or the `ai` flake as
  inputs. The shell setup comes from `viicslen-nix/home`, and nothing else is
  shared.
- **Shell config goes in `viicslen-nix/home`, not here.** A change made here
  drifts from the NixOS hosts. Only phone-specific settings belong in
  `presets/*/home.nix` (for example `jujutsu.meld = false`).
- **Layout.** A host is listed in `hosts/default.nix` with its `presets`. Its
  `hosts/<name>/home.nix` is added to `home-manager.sharedModules` by
  `parts/hosts.nix`, so don't import it. A preset is `default.nix` +
  `home.nix`. A new `parts/*.nix` file is imported automatically.
- **No duplicate packages.** A package that a home-manager module already
  installs (git, tmux, btop, fzf, zoxide, starship, the shells) is not listed in
  `environment.packages` too.
- **Verify by evaluating, not building.** From an x86_64 machine,
  `just eval` evaluates the aarch64 package profile and home-manager
  generation without building anything. The full `activationPackage` cannot be
  evaluated off the phone: nix-on-droid `builtins.storePath`s a proot binary
  that only its own cache has. Inside `/etc/nixos` (where this is a submodule), wrap it as that
  repo's `AGENTS.md` requires: capped, one at a time.
- **New files need `git add`** before nix can see them.
- **Never run `nix-on-droid switch`.** The user does that on the phone.
