//
//  MMBarricadeErrors.h
//  Barricade
//
//  Created by John McIntosh on 5/15/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, MMBarricadeError) {
    // MMBarricade NSURLProtocol
    MMBarricadeErrorNoRegisteredResponse = 100,
    // Response Generation
    MMBarricadeErrorInvalidJSON = 200,
    MMBarricadeErrorJSONSerialization = 201,
    MMBarricadeErrorNilFilepath = 202,
    MMBarricadeErrorFileReading = 203,
};
