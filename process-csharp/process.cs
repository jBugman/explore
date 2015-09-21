using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class ProcessCsharp {

    const int SUCCESS = 0;
    const int FAIL    = 1;

    static public int Process(String field, String folder) {
        var frequencies = new Dictionary<String, int>();
        foreach(String path in Directory.GetFiles(folder, "*.json")) {
            var raw = File.ReadAllText(path);
            var json = JObject.Parse(raw);
            var val = json[field];
            if (val == null) {
                Console.Error.WriteLine("Field is missing");
                return FAIL;
            } else if (val.Type != JTokenType.String) {
                Console.Error.WriteLine("Field is not a string");
                return FAIL;
            } else {
                var key = val.ToObject<String>();
                if (key != "") {
                    int count;
                    if(frequencies.TryGetValue(key, out count)) {
                        frequencies[key] = count + 1;
                    } else {
                        frequencies.Add(key, 1);
                    }
                }
            }
        }
        var sorted = from pair in frequencies orderby pair.Value descending select pair;
        foreach (KeyValuePair<String, int> pair in sorted) {
            Console.WriteLine("{0}: {1}", pair.Key, pair.Value);
        }
        return SUCCESS;
    }

    static public void Main(String[] args) {
        if (args.Length < 2) {
            Console.Error.WriteLine("Args are: <field name> <folder>");
            System.Environment.Exit(FAIL);
        } else {
            var exitCode = Process(args[0], args[1]);
            System.Environment.Exit(exitCode);
        }
    }
}
