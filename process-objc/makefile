.PHONY: build

CFLAGS = -fobjc-arc -fmodules -Wall -Wno-objc-designated-initializers -ICHCSVParser

deps:
	pod install --no-repo-update --no-integrate
	cp -rf Pods/CHCSVParser/CHCSVParser/CHCSVParser .
	rm -rf ./Pods

build:
	clang $(CFLAGS) -O2 -o build/process CHCSVParser/CHCSVParser.m process.m main.m

run:
	build/process Name ../test_data/

test:
	xcodebuild test -project Process.xcodeproj -scheme Process
