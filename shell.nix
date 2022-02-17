let
  drv = import ./nix/release.nix {};
  devTools = with drv.nixpkgs; [
    cabal-install
    haskell-language-server
  ];
in
  drv.env.overrideAttrs (oldEnv: {
    nativeBuildInputs = oldEnv.nativeBuildInputs ++ devTools;
  })
