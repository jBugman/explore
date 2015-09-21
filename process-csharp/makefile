all: run

JSON_NAME = Newtonsoft.Json
JSON_VERSION = 7.0.1
JSON_PATH = lib/$(JSON_NAME).$(JSON_VERSION)/lib/net40/

run: build
	MONO_PATH=$(JSON_PATH) mono build/process.exe Name ../test_data/

clean:
	@rm -rf build

deps:
	mono nuget.exe install -o lib $(JSON_NAME) -version $(JSON_VERSION)

build:
	@mkdir -p build
	mcs -lib:$(JSON_PATH) -reference:$(JSON_NAME) -out:build/process.exe process.cs
