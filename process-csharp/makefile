.PHONY: build

NUGET = ~/Applications/nuget.exe
JSON_NAME = Newtonsoft.Json
JSON_VERSION = 7.0.1
JSON_PATH = lib/$(JSON_NAME).$(JSON_VERSION)/lib/net40/
CSV_NAME = CsvHelper
CSV_VERSION = 2.13.2.0
CSV_PATH = lib/$(CSV_NAME).$(CSV_VERSION)/lib/net40-client/
BUILD_DEPS = -lib:$(JSON_PATH),$(CSV_PATH) -r:$(JSON_NAME) -r:$(CSV_NAME)
MONO_PATH = $(JSON_PATH):$(CSV_PATH)

run:
	MONO_PATH=$(MONO_PATH) mono build/process.exe Name ../test_data/

deps:
	mono $(NUGET) install -o lib $(JSON_NAME) -version $(JSON_VERSION)
	mono $(NUGET) install -o lib $(CSV_NAME) -version $(CSV_VERSION)

build:
	@mkdir -p build
	mcs $(BUILD_DEPS) -out:build/process.exe process.cs

test:
	@mkdir -p build
	mcs -t:library $(BUILD_DEPS) -r:nunit.framework -out:build/process_test.dll process.cs process_test.cs
	MONO_PATH=$(MONO_PATH) nunit-console build/process_test.dll -xml=/dev/null
