-module(process_app).
%%! -pa deps/jsx/ebin
-export([process/2, main/1]).

main([Field, Folder]) -> io:format("Hello World!~n", []), io:format("~p~n", [jsx:decode(<<"{\"deps import\": \"ok\"}">>)]);
main(_) -> io:format("Args are: <field name> <folder>~n", []), halt(1).

process(Field, Folder) ->
    Files = filelib:wildcard(Folder ++ "*.json"),
    Files.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
no_crash_test() -> process("Name", "../test_data/").
-endif.
