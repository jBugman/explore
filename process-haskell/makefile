deps:
	cabal sandbox init
	cabal update
	cabal configure -O2
	cabal install --only-dependencies -j4

build:
	cabal build

run:
	dist/build/process/process Name ../test_data/

