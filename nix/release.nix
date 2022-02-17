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

  entrypoint = nixpkgs.stdenv.mkDerivation rec {
    name         = "entrypoint-for-image";
    src          = ./.;
    installPhase = ''
      mkdir -p $out/bin
      cp entrypoint $out/bin
    '';
  };
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

    docker-ci = nixpkgs.dockerTools.buildImage {
      name     = "${project.pname}-ci";
      tag      = project.version;
      contents = with nixpkgs; [
        project
        entrypoint
        bash
        cabal-install
        coreutils
        haskellPackages.hlint
        haskellPackages.stylish-haskell
      ];
      config.Entrypoint = [ "${entrypoint}/bin/entrypoint" ];
    };
  }
