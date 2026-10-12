{
  inputs,
  pkgs,
  ...
}: {
  environment = {
    # git, gh, hunk, tmux, btop, fzf, zoxide, starship, man and the shells come from the
    # home-manager modules; don't list them here too.
    packages = with pkgs; [
      neovim
      vim
      nano
      openssh

      lsd
      bat
      ripgrep
      fd
      jq
      jc
      pv
      just
      tlrc
      unzip
      pigz

      which
      gnugrep
      gnused
      gnutar
      gzip
      findutils
      diffutils
      procps
      hostname
    ];

    # Back up an existing /etc file instead of failing the activation.
    etcBackupExtension = ".bak";
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  user.shell = "${pkgs.zsh}/bin/zsh";

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "hm-bak";
    extraSpecialArgs = {inherit inputs;};

    # Must be non-null, or nix-on-droid skips home-manager entirely; the real
    # config is in sharedModules.
    config = {};
    sharedModules = [./home.nix];
  };
}
