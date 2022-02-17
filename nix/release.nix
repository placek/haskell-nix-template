{ name ? "foobar" }:
let
  nixpkgs = import ./nixpkgs.nix {
    overlays = [
      (final: prev: {
        myHaskellPackages = final.haskellPackages.override (old: {
          overrides = final.lib.composeExtensions (old.overrides or (_: _: {})) haskellPkgsOverlay;
        });
      })
    ];
  };

  haskellPkgsOverlay = (final: prev: {
    project = final.callCabal2nix name ./.. {};
  });

  inherit (nixpkgs.myHaskellPackages) project;
in
  {
    inherit nixpkgs project;
    inherit (project) env;

    docker = nixpkgs.dockerTools.buildImage {
      name     = project.pname;
      tag      = project.version;
      contents = with nixpkgs; [
        (haskell.lib.justStaticExecutables project)
        busybox
      ];
    };
  }
