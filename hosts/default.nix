_: {
  hosts = {
    # `default`, so a bare `nix-on-droid switch --flake .` finds it.
    default = {
      system = "aarch64-linux";
      presets = ["base"];
    };
  };
}
