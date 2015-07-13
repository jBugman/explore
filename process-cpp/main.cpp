#include <iostream>
#include <fstream>
#include <string>
#include <unordered_map>
#include <set>
#include <glob.h>
#include "json.h"

using namespace std;

std::string replaceAll(const std::string& str, const std::string& from, const std::string& to) {
    string strCopy = str;
    size_t start_pos = 0;
    while((start_pos = strCopy.find(from, start_pos)) != std::string::npos) {
        strCopy.replace(start_pos, from.length(), to);
        start_pos += to.length(); // In case 'to' contains 'from', like replacing 'x' with 'yx'
    }
    return strCopy;
}

void processFolder(const std::string& pat, const std::string& key){
    using namespace std;
    glob_t glob_result;
    glob(pat.c_str(),GLOB_TILDE,NULL,&glob_result);
    
    unordered_map<string, unsigned int> frequencies;
    
    for(unsigned int i=0;i<glob_result.gl_pathc;++i){
        ifstream fileInput{glob_result.gl_pathv[i]};
        Json::Value root;
        
        fileInput >> root;
        
        if (!root.isMember(key)) {
            cerr << "Field is missing" << endl;
            exit(-1);
        }
        auto valueNode = root[key];
        if (valueNode.type() != Json::ValueType::stringValue) {
            cerr << "Field is not a string" << endl;
            exit(-2);
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
        return v1.second <= v2.second;
    };
    
    set<pair<string, int>, decltype(compareByValue)> kvs(frequencies.cbegin(), frequencies.cend(), compareByValue);
    
    ofstream output("output.csv");
    for (auto& kv : kvs) {
        output << "\"" << replaceAll(kv.first, "\"", "\"\"") << "\","<< kv.second << endl;
    }
}

int main(int argc, const char * argv[]) {
    processFolder(string(argv[2])+"/*.json", argv[1]);
    return 0;
}
