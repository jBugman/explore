-module(process_app).
%%! -pa deps/jsx/ebin -pa deps/erl_csv_generator/ebin
-export([process/2, main/1]).

main([Field, Folder]) -> process(Field, Folder);
main(_) -> io:format("Args are: <field name> <folder>~n", []), halt(1).

process(Field, Folder) ->
    Files = filelib:wildcard(Folder ++ "*.json"),
    Values = lists:filtermap(fun(F) ->
        {ok, Binary} = file:read_file(F),
        Json = jsx:decode(Binary, [return_maps]),
        case maps:find(list_to_binary(Field), Json) of
            {ok, Value} -> case is_binary(Value) of
                true -> case binary_to_list(Value) of
                    "" -> false;
                    X -> {true, X}
                end;
                false -> erlang:error("Field is not a string")
            end;
            error -> erlang:error("Field is missing")
        end
    end, Files),
    Frequencies = lists:reverse(lists:keysort(2, count_items(Values))),
    {ok, CsvFile} = file:open("output.csv", [write]),
    lists:foreach(fun({K, V}) -> csv_gen:row(CsvFile, [K, V]) end, Frequencies),
    file:close(CsvFile).

count_items(XS) -> dict:to_list(lists:foldl(fun(X, D) -> dict:update_counter(X, 1, D) end, dict:new(), XS)).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
no_crash_test() -> process("Name", "../test_data/").
-endif.
