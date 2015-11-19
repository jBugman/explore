#include <cstdlib>
#include <string>
#include <iostream>
#include "process.h"

using namespace std;

int main(int argc, const char * argv[]) {
  for(int i = 0; i < 100; i++) {
    process("Name", "../test_data/");
  }
  return EXIT_SUCCESS;
}
