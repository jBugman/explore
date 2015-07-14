@import Foundation;
#import "CHCSVParser/CHCSVParser.h"
#import "process.h"

int process(NSString* field, NSString* folder) {
    NSArray* dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:nil];
    NSArray* jsons = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.json'"]];

    NSCountedSet* frequencies = [NSCountedSet setWithCapacity:32];
    for (NSString* fileName in jsons) {
        NSString* path = [folder stringByAppendingPathComponent:fileName];
        NSString* rawJSON = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        NSError* jsonError;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[rawJSON dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:0 error:&jsonError];
        if (jsonError != nil) {
            fputs("Marformed JSON\n", stderr);
            return EXIT_FAILURE;
        }
        id value = [json valueForKey:field];
        if (value == nil) {
            fputs("Field is missing\n", stderr);
            return EXIT_FAILURE;
        }
        if (![value isKindOfClass:[NSString class]]) {
            fputs("Field is not a string\n", stderr);
            return EXIT_FAILURE;
        }
        if ([value length] != 0) {
            [frequencies addObject:value];
        }
    }

    NSMutableArray* items = [NSMutableArray array];
    [frequencies enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [items addObject:@{@"key": obj, @"count": @([frequencies countForObject:obj])}];
    }];
    NSArray* sorted = [items sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO]]];

    CHCSVWriter* csv = [[CHCSVWriter alloc] initForWritingToCSVFile:@"output.csv"];
    for (NSObject* item in sorted) {
        [csv writeField:[item valueForKey:@"key"]];
        [csv writeField:[item valueForKey:@"count"]];
        [csv finishLine];
    }

    return EXIT_SUCCESS;
}
