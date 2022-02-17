let
  drv = import ./nix/release.nix {};
  devTools = with drv.nixpkgs; [
    cabal-install
    haskell-language-server
  ];
in
  drv.project.env.overrideAttrs (oldEnv: {
    nativeBuildInputs = oldEnv.nativeBuildInputs ++ devTools;
  })
