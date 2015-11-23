.PHONY: build

build_llvm:
	ldc2 -w -O3 -release -enable-inlining -of=build/process process.d

build:
	dmd -w -O -release -inline -boundscheck=off -ofbuild/process process.d

run:
	build/process Name ../test_data/

test:
	dmd -w -unittest -ofbuild/test process.d
	build/test
