#include <cstdlib>
#include "gtest/gtest.h"
#include "process.h"

TEST(Process, Works) {
    EXPECT_EQ(process("Name", "../test_data/"), EXIT_SUCCESS);
}

GTEST_API_ int main(int argc, char **argv) {
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
