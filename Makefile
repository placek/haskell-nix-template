all:
	cabal build all

specs:
	cabal test

clean:
	git clean -nfdx
