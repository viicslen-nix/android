############################################################################
#
#  On the phone
#
############################################################################

# Build and activate a host (the default one is `default`)
switch HOST='default' *ARGS:
  nix-on-droid switch --flake .#{{HOST}} {{ARGS}}

# Build a host without activating it
build HOST='default' *ARGS:
  nix-on-droid build --flake .#{{HOST}} {{ARGS}}

# Go back to the previous generation
rollback:
  nix-on-droid rollback

# List generations
generations:
  nix-on-droid generations

############################################################################
#
#  Anywhere
#
############################################################################

# Evaluate a host's package profile and home-manager generation without building
# (works from x86_64; the full activationPackage needs proot from the phone's cache)
eval HOST='default':
  nix eval --raw .#nixOnDroidConfigurations.{{HOST}}.config --apply 'c: c.environment.path.drvPath + " " + c.home-manager.config.home.activationPackage.drvPath'

# Report deadnix and statix findings without editing (`just fmt` fixes what it can)
lint PATH='.':
  nix shell nixpkgs#deadnix nixpkgs#statix -c sh -c 'deadnix --fail -- {{PATH}} && statix check {{PATH}}'

# Format the nix files in this repo
fmt PATH='.' *ARGS:
  nix fmt {{PATH}} {{ARGS}}

# Run the flake checks (treefmt, statix)
check *ARGS:
  nix flake check {{ARGS}}

# Update all inputs
update *ARGS:
  nix flake update {{ARGS}}

# Update one input; `just update-input home` picks up a pushed viicslen-nix/home change
update-input INPUT *ARGS:
  nix flake update {{INPUT}} {{ARGS}}
