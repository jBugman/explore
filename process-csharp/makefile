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

test:
	@mkdir -p build
	mcs -t:library -lib:$(JSON_PATH) -r:$(JSON_NAME) -r:nunit.framework -out:build/process_test.dll process.cs process_test.cs
	MONO_PATH=$(JSON_PATH) nunit-console build/process_test.dll -xml=/dev/null
