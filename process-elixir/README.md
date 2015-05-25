Interactive

	mix deps.get
	iex -S mix
	c "lib/process.ex"
	Process.CLI.main ["Name", "../test_data"]

Standalone

	mix deps.get
	mix escript.build
	./process Name ../test_data/

