.PHONY: build

CFLAGS = -std=c++11 `pkg-config --cflags --libs jsoncpp` -Wall

build:
	clang++ ${CFLAGS} -Wall -O3 -o build/process process.cpp main.cpp

run:
	@build/process Name ../test_data

memcheck:
	valgrind --gen-suppressions=all --leak-check=full --show-leak-kinds=all --show-reachable=no --show-possibly-lost=no --dsymutil=yes build/process Name ../test_data/

test:
	@clang++ ${CFLAGS} -lgtest -o build/test process.cpp test.cpp
	build/test
