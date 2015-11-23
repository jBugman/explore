import std.algorithm.searching;
import std.algorithm.sorting;
import std.array;
import std.file;
import std.json;
import std.stdio;

unittest {
    assert(process("Name", "../test_data") == 0);
}

string toCSV(string x) {
    auto result = x.replace("\"", "\"\"");
    if (canFind(result, '\n') || canFind(result, ',')) {
        result = "\"" ~ result ~ "\"";
    }
    return result;
}

int process(const string field, const string folder) {
    int[string] frequencies;
    auto files = dirEntries(folder, "*.json", SpanMode.shallow);
    foreach(file; files) {
        auto data = parseJSON(readText(file));
        if (field !in data) {
            stderr.writeln("Field is missing");
            return 1;
        }
        auto jsonValue = data[field];
        if (jsonValue.type != JSON_TYPE.STRING) {
            stderr.writeln("Field is not a string");
            return 1;
        }
        auto value = jsonValue.str;
        if (value != "") {
            frequencies[value]++;
        }
    }
    auto sortedKeys = frequencies.keys;
    sort!((a, b) => frequencies[a] > frequencies[b])(sortedKeys);
    auto f = File("output.csv", "w");
    foreach(key; sortedKeys) {
        f.writef("%s,%d\n", toCSV(key), frequencies[key]);
    }
    return 0;
}

int main(string[] args) {
    if (args.length != 3) {
        writeln("Args are: <field name> <folder>");
        return 0;
    } else {
        return process(args[1], args[2]);
    }
}

// // Benchmark
// void main(string[] args) {
//     for(int i = 0; i < 100; i++) {
//         process("Name", "../test_data/");
//     }
// }
