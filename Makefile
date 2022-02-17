all:
	cabal build all

test:
	cabal test

clean:
	git clean -nfdx
