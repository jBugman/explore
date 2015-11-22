.PHONY: build

# MAC OS X only. Homebrewed libcsv does nt provide pkg-config info.
LIBCSV_BASE = /usr/local/Cellar/libcsv/3.0.3
LIBCSV_FLAGS = -I$(LIBCSV_BASE)/include -L$(LIBCSV_BASE)/lib -lcsv

CFLAGS = `pkg-config --libs yajl` `pkg-config --cflags --libs glib-2.0` $(LIBCSV_FLAGS) -Wall

build:
	@mkdir -p build
	clang $(CFLAGS) -O2 -o build/process process.c main.c

run:
	build/process Name ../test_data/

memcheck:
	valgrind --gen-suppressions=all --leak-check=full --show-leak-kinds=all --show-reachable=no --show-possibly-lost=no --dsymutil=yes --suppressions=valgrind.supp build/process Name ../test_data/

test:
	checkmk test.check > build/test.c
	clang $(CFLAGS) `pkg-config --libs check` -o build/test process.c build/test.c
	@echo
	@build/test
