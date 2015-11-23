import Foundation

func fail(message: String) -> Int32 {
    fputs(message + "\n", stderr)
    return EXIT_FAILURE
}

func process(field: String, folder: String) -> Int32 {
    let files = try? NSFileManager().contentsOfDirectoryAtPath(folder).filter({ $0.hasSuffix(".json") })

    var frequencies = Dictionary<String, Int>()
    for filename in files! {
        let path = (folder as NSString).stringByAppendingPathComponent(filename)
        if let rawJson = (try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding))?.dataUsingEncoding(NSUTF8StringEncoding) {
            if let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(rawJson, options: NSJSONReadingOptions()) {
                switch json?.valueForKey(field) {
                case nil: return fail("Field is missing")
                case let x as String where x == "": break
                case let key as String: if let count = frequencies[key] {
                    frequencies[key] = count + 1
                } else {
                    frequencies[key] = 1
                }
                default: return fail("Field is not a string")
                }
            } else {
                return fail("Malformed JSON")
            }
        }
    }

    let csv = CHCSVWriter(forWritingToCSVFile: "output.csv")
    (frequencies as NSDictionary).keysSortedByValueUsingComparator({
        ($1 as! NSNumber).compare($0 as! NSNumber)
    }).forEach({ key -> () in
        csv.writeField(key)
        csv.writeField(frequencies[key as! String]!)
        csv.finishLine()
    })
    return EXIT_SUCCESS
}

if Process.argc < 3 {
    fputs("Args are: <field name> <folder>\n", stderr)
    exit(EXIT_FAILURE)
} else {
    exit(process(Process.arguments[1], folder: Process.arguments[2]))
}

//// Benchmark
//for (var i = 0; i < 100; i++) {
//    process("Name", folder: "../test_data/")
//}
