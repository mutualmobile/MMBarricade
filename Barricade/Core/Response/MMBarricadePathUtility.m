//
//  MMBarricadePathUtility.m
//  Barricade
//
//  Created by John McIntosh on 5/15/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMBarricadePathUtility.h"


NSString * MMPathForFileInMainBundle(NSString *filename) {
    NSBundle *bundle = [NSBundle mainBundle];
    return MMPathForFileInBundle(filename, bundle);
}

NSString * MMPathForFileInMainBundleDirectory(NSString *filename, NSString *directory) {
    NSBundle *bundle = [NSBundle mainBundle];
    return MMPathForFileInDirectoryInBundle(filename, directory, bundle);
}

NSString * MMPathForFileInBundle(NSString *filename, NSBundle *bundle) {
    return [bundle.bundlePath stringByAppendingPathComponent:filename];
}

NSString * MMPathForFileInDirectoryInBundle(NSString *filename, NSString *directory, NSBundle *bundle) {
    return [bundle pathForResource:filename ofType:nil inDirectory:directory];
}

NSString * MMPathForFileInDocumentsDirectory(NSString *filename) {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [documentsPath stringByAppendingPathComponent:filename];
}
