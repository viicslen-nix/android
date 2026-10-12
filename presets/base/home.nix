{inputs, ...}: {
  imports = [inputs.home.homeManagerModules.default];

  modules.programs = {
    # The phone has no display for meld, no private key to sign with, and no
    # container engine.
    jujutsu.meld = false;
    shellProfile.signingKey = null;
    nushell.enableContainerIntegration = false;
  };
}
