<div align="center">

# android

**My terminal on the phone: [nix-on-droid](https://github.com/nix-community/nix-on-droid) with the same shell setup as every NixOS machine.**

[![flake-parts](https://img.shields.io/badge/built_with-flake--parts-7EBAE4?style=flat-square&logo=nixos&logoColor=white)](https://flake.parts)
[![nix-on-droid](https://img.shields.io/badge/nix--on--droid-master-3DDC84?style=flat-square&logo=android&logoColor=white)](https://github.com/nix-community/nix-on-droid)
[![nixpkgs unstable](https://img.shields.io/badge/nixpkgs-unstable-5277C3?style=flat-square&logo=nixos&logoColor=white)](https://github.com/NixOS/nixpkgs/tree/nixos-unstable)
[![treefmt](https://img.shields.io/badge/lint-deadnix_·_statix_·_alejandra-41439A?style=flat-square)](https://github.com/numtide/treefmt-nix)

</div>

zsh, tmux, starship, atuin, nushell, git and jujutsu come from
[viicslen-nix/home](https://github.com/viicslen-nix/home), the same modules
[viicslen-nix/nixos](https://github.com/viicslen-nix/nixos) uses, so the phone
can't drift from the desktop. The repo follows that one's layout. It leaves out
nixvim and the AI harnesses on purpose.

## Contents

- [Install](#install)
- [What you get](#what-you-get)
- [Layout](#layout)
- [Recipes](#recipes)
- [Changing the shell setup](#changing-the-shell-setup)

## Install

In a fresh nix-on-droid session:

```sh
nix-on-droid switch --flake github:viicslen-nix/android
```

The only host is `default`, so no `#attribute` is needed. After that, from a
clone:

```sh
git clone https://github.com/viicslen-nix/android && cd android
just switch
```

> [!IMPORTANT]
> The first switch compiles `jj-starship` on the phone. It comes from a flake,
> not nixpkgs, so no binary cache has it. Plug the phone in.

## What you get

| | |
| --- | --- |
| **Login shell** | zsh, with nushell a `tmux` pane away |
| **Shell setup** | Everything in [viicslen-nix/home](https://github.com/viicslen-nix/home): prompt, history, aliases, fzf/zoxide/direnv, git and jj identity |
| **CLI** | neovim, vim, nano, gh, openssh, lsd, bat, ripgrep, fd, jq, jc, just, tlrc, … |
| **Nix** | flakes and `nix-command` on |

What the phone turns off from the shared modules:

| Setting | Why |
| --- | --- |
| `jujutsu.meld = false` | meld is a GTK app; there is no display |
| `shellProfile.signingKey = null` | The private key isn't on the phone, so commits go unsigned |
| `nushell.enableContainerIntegration = false` | No docker or podman |

## Layout

```text
flake.nix            # inputs only; every parts/*.nix is auto-imported
parts/               # flake-parts modules: systems, hosts, formatter + checks
hosts/default.nix    # the host list and the presets each one gets
hosts/<name>/        # machine facts (default.nix) and home-manager (home.nix)
presets/<name>/      # default.nix (nix-on-droid) + home.nix (home-manager)
```

| Preset | Provides |
| --- | --- |
| `base` | Nix flakes, the CLI set, zsh as the login shell, and the shell setup from `home` |

## Recipes

| Recipe | Does |
| --- | --- |
| `just switch [HOST]` | Build and activate a host |
| `just build [HOST]` | Build without activating |
| `just rollback` / `just generations` | Step back a generation / list them |
| `just eval [HOST]` | Evaluate the package profile and home-manager generation; works from x86_64 |
| `just lint` / `just fmt` / `just check` | deadnix + statix / treefmt / flake checks |
| `just update` / `just update-input X` | Bump every input / one |

> [!NOTE]
> The full `activationPackage` can't be evaluated off the phone: nix-on-droid
> loads a proot binary with `builtins.storePath`, and only its own cache has
> it. `just eval` covers everything this repo defines.

## Changing the shell setup

Make the change in [viicslen-nix/home](https://github.com/viicslen-nix/home)
and push it, then pull it in here:

```sh
just update-input home
```

Only settings that are specific to the phone belong in `presets/*/home.nix`.
