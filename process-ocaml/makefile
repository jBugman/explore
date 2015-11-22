deps:
	opam init
	eval `opam config env`
	opam install core yojson

test:
	corebuild -package ounit test.byte --

build:
	corebuild process.native process.byte

run:
	corebuild process.native -- Name ../test_data/

run_bytecode:
	corebuild process.byte -- Name ../test_data/
