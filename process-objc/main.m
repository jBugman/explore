@import Foundation;
#import "process.h"

int main(int argc, const char * argv[]) {
    if (argc < 3) {
        fputs("Args are: <field name> <folder>\n", stderr);
        return EXIT_FAILURE;
    }
    int result;
    @autoreleasepool {
        result = process([NSString stringWithUTF8String:argv[1]], [NSString stringWithUTF8String:argv[2]]);
    }
    return result;
}