import Foundation

func fail(message: String) -> Int32 {
    fputs(message + "\n", stderr)
    return EXIT_FAILURE
}

func process(field: String, folder: String) -> Int32 {
    let files = NSFileManager().contentsOfDirectoryAtPath(folder, error: nil)?
    .map({ $0 as! String })
    .filter({ $0.hasSuffix(".json") })

    var frequencies = Dictionary<String, Int>()
    for filename in files! {
        let path = folder.stringByAppendingPathComponent(filename)
        if let rawJson = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)?.dataUsingEncoding(NSUTF8StringEncoding) {
            if let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(rawJson, options: NSJSONReadingOptions.allZeros, error: nil) {
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
    let sorted = (frequencies as NSDictionary).keysSortedByValueUsingComparator({
        ($1 as! NSNumber).compare($0 as! NSNumber)
    }).map({ key -> () in
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
    exit(process(Process.arguments[1], Process.arguments[2]))
}
