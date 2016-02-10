.PHONY: build

NUGET = ~/Applications/nuget.exe
JSON_NAME = FSharp.Data
JSON_VERSION = 2.2.5
JSON_PATH = lib/$(JSON_NAME).$(JSON_VERSION)/lib/net40/
CSV_NAME = CsvHelper
CSV_VERSION = 2.13.2.0
CSV_PATH = lib/$(CSV_NAME).$(CSV_VERSION)/lib/net40-client/
FSUNIT_NAME = FsUnit
FSUNIT_VERSION = 2.0.0
FSUNIT_PATH = lib/$(FSUNIT_NAME).$(FSUNIT_VERSION)/lib/net45/
NUNIT_VERSION = 3.0.1
NUNIT_PATH = lib/NUnit.$(NUNIT_VERSION)/lib/net40/
BUILD_DEPS = --lib:$(JSON_PATH),$(CSV_PATH) -r:$(JSON_NAME) -r:$(CSV_NAME)
TEST_DEPS = --lib:$(JSON_PATH),$(CSV_PATH),$(FSUNIT_PATH),$(NUNIT_PATH) -r:$(JSON_NAME) -r:$(CSV_NAME) -r:FsUnit.NUnit -r:nunit.framework
MONO_PATH = $(JSON_PATH):$(CSV_PATH)
TEST_PATH = $(MONO_PATH):$(FSUNIT_PATH):$(NUNIT_PATH)

deps:
	mono $(NUGET) install -o lib $(JSON_NAME) -version $(JSON_VERSION)
	mono $(NUGET) install -o lib $(CSV_NAME) -version $(CSV_VERSION)
	mono $(NUGET) install -o lib $(FSUNIT_NAME) -version $(FSUNIT_VERSION)

build:
	@mkdir -p build
	fsharpc $(BUILD_DEPS) -O --out:build/process.exe process.fs main.fs

run:
	MONO_PATH=$(MONO_PATH) mono build/process.exe Name ../test_data/

test:
	@mkdir -p build
	fsharpc --target:library $(TEST_DEPS) --out:build/process_test.dll process.fs process_test.fs
	MONO_PATH=$(TEST_PATH) nunit-console build/process_test.dll -xml=/dev/null
