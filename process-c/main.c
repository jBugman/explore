#include "process.h"

int main (int argc, char const *argv[]) {
  if (argc < 3) {
    fputs("Args are: <field name> <folder>\n", stderr);
    return 1;
  }
  return process(argv[1], argv[2]);
}

// Benchmark
// int main(int argc, const char * argv[]) {
//   for(int i = 0; i < 100; i++) {
//     process("Name", "../test_data/");
//   }
//   return 0;
// }
