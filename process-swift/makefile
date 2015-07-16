all: build run

deps:
	pod install --no-repo-update --no-integrate
	cp -rf Pods/CHCSVParser/CHCSVParser/CHCSVParser .
	rm -rf ./Pods

build: clean
	@mkdir -p build
	xcrun clang -fobjc-arc -Wall -Wno-objc-designated-initializers -o build/CSV.o -c CHCSVParser/CHCSVParser.m
	xcrun -sdk macosx swiftc -import-objc-header Process-Bridging-Header.h -O -o build/Process.o -c Process/main.swift
	xcrun swiftc -o build/process build/CSV.o build/Process.o

clean:
	@rm -rf build

run: build
	@build/process Name ../test_data/

test:
	xcodebuild test -project Process.xcodeproj -scheme Process
