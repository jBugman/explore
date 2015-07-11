all: build run

# MAC OS X only. Homebrewed libcsv does nt provide pkg-config info.
LIBCSV_BASE = /usr/local/Cellar/libcsv/3.0.3
LIBCSV_FLAGS = -I$(LIBCSV_BASE)/include -L$(LIBCSV_BASE)/lib -lcsv

build: clean
	@mkdir -p build
	clang `pkg-config --libs yajl` `pkg-config --cflags --libs glib-2.0` $(LIBCSV_FLAGS) -Wall -o build/process process.c

clean:
	@rm -rf build

run: build
	@build/process Name ../test_data/

memcheck: build
	valgrind --gen-suppressions=all --leak-check=full --show-leak-kinds=all --show-reachable=no --show-possibly-lost=no --dsymutil=yes --suppressions=valgrind.supp build/process Name ../test_data/
