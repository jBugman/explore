#include "process.h"

int main (int argc, char const *argv[]) {
  for(int i = 0; i < 100; i++) {
    process("Name", "../test_data/");
  }
  return 0;
}