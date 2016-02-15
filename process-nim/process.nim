import json
import os
import tables
import csv

proc process(field, folder: string): int =
  var frequencies = initCountTable[string](32)
  for file in walkFiles joinPath(folder, "*.json"):
    let data = parseFile(file)
    if not data.hasKey(field):
      stderr.writeLine("Field is missing")
      return QuitFailure

    let jValue = data[field]
    if jValue.kind != JString:
      stderr.writeLine("Field is not a string")
      return QuitFailure

    let key = jValue.getStr()
    if key != "":
      frequencies.inc(key)
  
  frequencies.sort()
  var csvLines = newSeq[seq[string]](0)
  for k, v in frequencies.pairs():
    csvLines.add @[k, repr v]
  discard writeAll("output.csv", csvLines)

  return QuitSuccess


proc main() =
  if paramCount() == 2:
    quit(process(paramStr(1), paramStr(2)))
  else:
    stderr.writeLine("Args are: <field name> <folder>")
    quit(QuitFailure)


when isMainModule:
  when defined(testing):
    import unittest
    suite "Process tests":
      test "Should work":
        check(QuitSuccess == process("Name", "../test_data/"))
  else:
    main()


# # Benchmark
# when isMainModule:
#   for i in countup(1, 100):
#     discard process("Name", "../test_data/")
