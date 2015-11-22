deps:
	luarocks-5.1 install luafilesystem
	luarocks-5.1 install lua-glob-pattern
	luarocks-5.1 install lua-cjson
	luarocks-5.1 install busted

run:
	lua-5.1 main.lua Name ../test_data/

test:
	busted process_test.lua
