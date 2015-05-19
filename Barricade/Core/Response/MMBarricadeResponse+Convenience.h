//
//  MMBarricadeResponse+Convenience.h
//  Barricade
//
//  Created by John McIntosh on 5/14/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMBarricadeResponse.h"


@interface MMBarricadeResponse (Convenience)

+ (instancetype)responseWithName:(NSString *)name error:(NSError *)error;

// JSON

+ (instancetype)responseWithName:(NSString *)name
                            JSON:(id)JSON
                      statusCode:(NSInteger)statusCode
                         headers:(NSDictionary *)headers;

+ (instancetype)responseWithName:(NSString *)name
                            JSON:(id)JSON
                      statusCode:(NSInteger)statusCode
                     contentType:(NSString *)contentType;

// File

+ (instancetype)responseWithName:(NSString *)name
                            file:(NSString *)filePath
                      statusCode:(NSInteger)statusCode
                         headers:(NSDictionary *)headers;

+ (instancetype)responseWithName:(NSString *)name
                            file:(NSString *)filePath
                      statusCode:(NSInteger)statusCode
                     contentType:(NSString *)contentType;

// Data

+ (instancetype)responseWithName:(NSString *)name
                            data:(NSData *)data
                      statusCode:(NSInteger)statusCode
                         headers:(NSDictionary *)headers;

+ (instancetype)responseWithName:(NSString *)name
                            data:(NSData *)data
                      statusCode:(NSInteger)statusCode
                     contentType:(NSString *)contentType;

@end
