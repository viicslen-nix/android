# viicslen-nix/android

**[nix-on-droid](https://github.com/nix-community/nix-on-droid) config for the phone.**

It follows the layout of [viicslen-nix/nixos](https://github.com/viicslen-nix/nixos)
and shares its shell setup through [viicslen-nix/home](https://github.com/viicslen-nix/home):
zsh, tmux, starship, atuin, nushell, git and jujutsu, all configured the same.
nixvim and the AI harnesses are not included.

## Layout

```
flake.nix            # inputs only; every parts/*.nix is auto-imported
parts/               # flake-parts modules: systems, hosts, formatter + checks
hosts/default.nix    # the host list and the presets each one gets
hosts/<name>/        # machine facts (default.nix) and home-manager (home.nix)
presets/<name>/      # default.nix (nix-on-droid) + home.nix (home-manager)
```

| Preset | Provides |
| --- | --- |
| `base` | Nix flakes, the CLI set, zsh as the login shell, and the shared shell profile from `home` |

The one host is `default`, so `nix-on-droid switch --flake .` needs no attribute.

## Use

On the phone:

```sh
nix-on-droid switch --flake github:viicslen-nix/android   # first time
just switch                                                # from a clone
```

| Recipe | Does |
| --- | --- |
| `switch` / `build` `[HOST]` | Activate / build a host |
| `rollback`, `generations` | nix-on-droid generation management |
| `eval [HOST]` | Evaluate the package profile and home-manager generation, also from x86_64 |
| `lint`, `fmt`, `check` | deadnix + statix, treefmt, flake checks |
| `update`, `update-input X` | Bump all inputs / one |

## Updating the shell setup

Change it in `viicslen-nix/home` and push, then run `just update-input home`
here.
