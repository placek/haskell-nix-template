{ name ? "foobar" }:
let
  nixpkgs = import ./nixpkgs.nix {
    overlays = [nixpkgsOverlay];
  };

  nixpkgsOverlay = (final: prev: {
    myHaskellPackages = final.haskellPackages.override (old: {
      overrides = final.lib.composeExtensions (old.overrides or (_: _: {})) haskellPkgsOverlay;
    });
  });

  haskellPkgsOverlay = (final: prev: {
    foobar = final.callCabal2nix "foobar" ./.. {};
  });

  devTools = with nixpkgs; [
    cabal-install
    haskell-language-server
  ];
in
  {
    inherit nixpkgs;
    project = nixpkgs.myHaskellPackages.foobar;
  }
