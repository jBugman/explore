all: build run

# MAC OS X only. Homebrewed libcsv does nt provide pkg-config info.
CFLAGS = -std=c++11 -I./json/ -Wall

build: clean
	@mkdir -p build
	clang++ $(CFLAGS) -O3 -o build/process main.cpp jsoncpp.cpp 

clean:
	@rm -rf build

run: build
	@build/process Name ../test_data

memcheck: build
	valgrind --gen-suppressions=all --leak-check=full --show-leak-kinds=all --show-reachable=no --show-possibly-lost=no --dsymutil=yes --suppressions=valgrind.supp build/process Name ../test_data/
