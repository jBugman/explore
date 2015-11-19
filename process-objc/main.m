@import Foundation;
#import "process.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        for(int i = 0; i < 100; i++) {
            process(@"Name", @"../test_data/");
        }
    }
    return 0;
}