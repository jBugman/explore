#include <iostream>
#include <fstream>
#include <string>
#include <unordered_map>
#include <set>
#include <cstdlib>
#include <glob.h>
#include "json/json.h"

#include "process.h"

using namespace std;

string replaceAll(const string& str, const string& from, const string& to) {
    string strCopy = str;
    size_t start_pos = 0;
    while((start_pos = strCopy.find(from, start_pos)) != string::npos) {
        strCopy.replace(start_pos, from.length(), to);
        start_pos += to.length(); // In case 'to' contains 'from', like replacing 'x' with 'yx'
    }
    return strCopy;
}

int process(const string& field, const string& folder) {
    glob_t glob_result;
    glob((folder + "/*.json").c_str(), GLOB_TILDE, NULL, &glob_result);

    unordered_map<string, unsigned int> frequencies;

    for(unsigned int i = 0; i < glob_result.gl_pathc; ++i) {
        ifstream fileInput{ glob_result.gl_pathv[i] };
        Json::Value root;

        fileInput >> root;

        if (!root.isMember(field)) {
            cerr << "Field is missing" << endl;
            return EXIT_FAILURE;
        }
        auto valueNode = root[field];
        if (valueNode.type() != Json::ValueType::stringValue) {
            cerr << "Field is not a string" << endl;
            return EXIT_FAILURE;
        }
        string value = valueNode.asString();
        if (!value.empty()) {
            frequencies[value] += 1;
        }
    }
    globfree(&glob_result);
    //sort by value
    // copy into vector
    auto compareByValue = [](pair<string, int> v1, pair<string, int>v2) {
        return v1.second >= v2.second;
    };

    set<pair<string, int>, decltype(compareByValue)> kvs(frequencies.cbegin(), frequencies.cend(), compareByValue);

    ofstream output("output.csv");
    for (const auto& kv : kvs) {
        output << "\"" << replaceAll(kv.first, "\"", "\"\"") << "\","<< kv.second << endl;
    }

    return EXIT_SUCCESS;
}
