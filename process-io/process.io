#!/usr/bin/env io
Yajl

main := method(args,
	if(args size < 3,
		"Args are: <field name> <folder>" println
	,
		process(args at(1), args at(2))
	)
)

List asCSV := method(map(x,
	x = x asString asMutable replaceSeq("\"", "\"\"")
	if(x containsSeq(",") or x containsSeq("\n"), "\"" .. x .. "\"", x)
) join(","))

process := method(field, folder,
	frequencies := Map clone
	Directory with(folder) filesWithExtension(".json") foreach(file,
		contents := file openForReading contents
		file close
		try(
			json := Yajl clone parse(contents) root at(0)
		) catch( Exception raise("Malformed JSON") )
		if(json hasKey(field),
			value := json at(field)
			if(value type != "Sequence", Exception raise("Field is not a string"))
			if(value != "", frequencies atPut(value, frequencies at(value, 0) + 1))
		,
			Exception raise("Field is missing")
		)
	)
	sorted := frequencies asList sortBy(block(a, b, a at(1) > b at(1)))

	outfile := File with("output.csv") open
	sorted foreach(line, outfile write(line asCSV, "\n"))
	outfile close
	return true
)

main(System args)
