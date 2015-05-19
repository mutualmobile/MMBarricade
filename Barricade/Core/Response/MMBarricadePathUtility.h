//
//  MMBarricadePathUtility.h
//  Barricade
//
//  Created by John McIntosh on 5/15/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>


NSString * MMPathForFileInMainBundle(NSString *filename);

NSString * MMPathForFileInMainBundleDirectory(NSString *filename, NSString *directory);

NSString * MMPathForFileInBundle(NSString *filename, NSBundle *bundle);

NSString * MMPathForFileInDirectoryInBundle(NSString *filename, NSString *directory, NSBundle *bundle);

NSString * MMPathForFileInDocumentsDirectory(NSString *filename);