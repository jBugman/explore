all: build run

build: clean
	@mkdir -p build
	clang `pkg-config --libs yajl` `pkg-config --cflags --libs glib-2.0` -Wall -o build/process process.c

clean:
	@rm -rf build

run: build
	@build/process Name ../test_data/

memcheck: build
	valgrind --gen-suppressions=all --leak-check=full --show-leak-kinds=all --show-reachable=no --show-possibly-lost=no --dsymutil=yes --suppressions=valgrind.supp build/process Name ../test_data/
