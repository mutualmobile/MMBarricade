//
//  MMBarricadePathUtilityTests.m
//  Barricade
//
//  Created by John McIntosh on 5/15/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMBarricadePathUtility.h"


@interface MMBarricadePathUtilityTests : XCTestCase

@end


@implementation MMBarricadePathUtilityTests

- (void)testPathForFileInMainBundle {
    NSString *path = MMPathForFileInMainBundle(@"app.bundle.txt");
    XCTAssertTrue([path hasSuffix:@".app/app.bundle.txt"]);
}

- (void)testPathForFileInMainBundleDirectory {
    NSString *path = MMPathForFileInMainBundleDirectory(@"file.response.txt", @"LocalServerResources");
    XCTAssertTrue([path hasSuffix:@".app/LocalServerResources/file.response.txt"]);
}

- (void)testPathForFileInBundle {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = MMPathForFileInBundle(@"app.bundle.txt", bundle);
    XCTAssertTrue([path hasSuffix:@".app/app.bundle.txt"]);
}

- (void)testPathForFileInDirectoryInBundle {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = MMPathForFileInDirectoryInBundle(@"file.response.txt", @"LocalServerResources", bundle);
    XCTAssertTrue([path hasSuffix:@".app/LocalServerResources/file.response.txt"]);
}

- (void)testPathForFileInDocumentsDirectory {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filename = @"in.documents.txt";
    [@"documents text" writeToFile:[documentsPath stringByAppendingPathComponent:filename]
                        atomically:YES
                          encoding:NSUTF8StringEncoding
                             error:nil];
    
    NSString *path = MMPathForFileInDocumentsDirectory(filename);
    XCTAssertTrue([path hasSuffix:@"/in.documents.txt"]);
    NSString *readString = [[NSString alloc] initWithContentsOfFile:path
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    XCTAssertEqualObjects(readString, @"documents text");
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

@end
