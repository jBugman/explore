#include <cstdlib>
#include <string>
#include <iostream>
#include "process.h"

using namespace std;

int main(int argc, const char * argv[]) {
    if (argc > 2) {
        return process(argv[1], argv[2]);
    } else {
        cerr << "Args are: <field name> <folder>\n";
        return EXIT_FAILURE;
    }
}
