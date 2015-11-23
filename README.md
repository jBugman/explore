Should take folder and field as parameters. Then scan all JSON files in that folder and generate CSV with sorted frequency report about strings in given field.

	[✓] C
	[✓] C#
	[✓] C++
	[✓] Clojure
	[✓] D
	[✓] Elixir
	[✓] Erlang
	[ ] F#
	[ ] Factor
	[✓] Go
	[✓] Haskell
	[✓] Hy
	[ ] Idris
	[✓] Io
	[✓] Java
	[✓] JavaScript (NodeJS)
	[ ] Kotlin
	[✓] Lua
	[ ] Nim
	[✓] Objective-C
	[✓] OCaml
	[✓] Perl
	[✓] Python
	[✓] Ruby
	[✓] Rust
	[✓] Scala
	[✓] Swift


[Benchmarks](https://docs.google.com/spreadsheets/d/1T3FIeAyycixbejNb94Cz4faSLg8OsMcVCWD5rFDej7I/edit?usp=sharingx) Timing for JVM-like languages is not that fair due to very short nature of task compared to VM startup cost. So we will repeat process call 100 times in main to get more accurate timing.
Also some results are strange (like Elixirs' x1-x100 small run time diference) and can mean there is caching involved.
