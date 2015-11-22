.PHONY: build

deps:
	rebar get-deps

build:
	rebar compile

run:
	ERL_LIBS=deps escript ./ebin/process_app.beam Name ../test_data/
