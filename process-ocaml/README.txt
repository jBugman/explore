opam install core yojson

corebuild process.byte -- Name ../test_data/

corebuild -package ounit test.byte --
