.PHONY: build

deps:
	pod install --no-repo-update --no-integrate
	cp -rf Pods/CHCSVParser/CHCSVParser/CHCSVParser .
	rm -rf ./Pods

build:
	xcrun clang -fobjc-arc -Wall -Wno-objc-designated-initializers -o build/CSV.o -c CHCSVParser/CHCSVParser.m
	xcrun -sdk macosx swiftc -import-objc-header Process-Bridging-Header.h -O -o build/Process.o -c Process/main.swift
	xcrun swiftc -o build/process build/CSV.o build/Process.o

run:
	build/process Name ../test_data/

test:
	xcodebuild test -project Process.xcodeproj -scheme Process
