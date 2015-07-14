all: run

CFLAGS = -std=c++11 `pkg-config --cflags --libs jsoncpp` -Wall

build: clean
	@mkdir -p build
	clang++ ${CFLAGS} -Wall -O3 -o build/process process.cpp main.cpp

clean:
	@rm -rf build

run: build
	@build/process Name ../test_data

memcheck: build
	valgrind --gen-suppressions=all --leak-check=full --show-leak-kinds=all --show-reachable=no --show-possibly-lost=no --dsymutil=yes build/process Name ../test_data/

test: clean
	@mkdir -p build
	@clang++ ${CFLAGS} -lgtest -o build/test process.cpp test.cpp
	build/test
