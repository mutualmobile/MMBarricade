//
//  MMBarricadeResponse+Convenience.m
//  Barricade
//
//  Created by John McIntosh on 5/14/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMBarricadeResponse+Convenience.h"
#import "MMBarricadeErrors.h"


@implementation MMBarricadeResponse (Convenience)

#pragma mark Error

+ (instancetype)responseWithName:(NSString *)name error:(NSError *)error {
    MMBarricadeResponse *response = [[[self class] alloc] init];
    response.name = name;
    response.error = error;
    return response;
}


#pragma mark JSON

+ (instancetype)responseWithName:(NSString *)name
                            JSON:(id)JSON
                      statusCode:(NSInteger)statusCode
                         headers:(NSDictionary *)headers {

    if ([NSJSONSerialization isValidJSONObject:JSON] == NO) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[NSLocalizedDescriptionKey] = @"The JSON object used to create this response was an invalid JSON object and could not be serialzed into a response.";
        userInfo[NSLocalizedFailureReasonErrorKey] = JSON;
        NSError *error = [NSError errorWithDomain:@"com.mutualmobile.barricade" code:MMBarricadeErrorInvalidJSON userInfo:userInfo];
        return [self responseWithName:name error:error];
    }
    else {
        NSError *parsingError = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:&parsingError];

        if (parsingError != nil) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[NSLocalizedDescriptionKey] = @"The JSON object used to create this response generated an error while being serialzed into data.";
            userInfo[NSLocalizedFailureReasonErrorKey] = JSON;
            userInfo[NSUnderlyingErrorKey] = parsingError;
            NSError *error = [NSError errorWithDomain:@"com.mutualmobile.barricade" code:MMBarricadeErrorJSONSerialization userInfo:userInfo];
            return [self responseWithName:name error:error];
        }
        else {
            MMBarricadeResponse *response = [[[self class] alloc] init];
            response.name = name;
            response.contentData = data;
            response.statusCode = statusCode;
            response.allHeaderFields = headers;
            return response;
        }
    }
}

+ (instancetype)responseWithName:(NSString *)name
                            JSON:(id)JSON
                      statusCode:(NSInteger)statusCode
                     contentType:(NSString *)contentType {

    NSDictionary *headers = [self headersWithContentType:contentType];
    return [self responseWithName:name JSON:JSON statusCode:statusCode headers:headers];
}


#pragma mark File

+ (instancetype)responseWithName:(NSString *)name
                            file:(NSString *)filePath
                      statusCode:(NSInteger)statusCode
                         headers:(NSDictionary *)headers {

    if (filePath.length == 0) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[NSLocalizedDescriptionKey] = @"A `nil` filepath was used to generate this response. Please double-check that you are using a valid file path.";
        NSError *error = [NSError errorWithDomain:@"com.mutualmobile.barricade" code:MMBarricadeErrorNilFilepath userInfo:userInfo];
        return [self responseWithName:name error:error];
    }
    else {
        NSError *readingError = nil;
        NSData *data = [NSData dataWithContentsOfFile:filePath options:0 error:&readingError];
        
        if (readingError != nil) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[NSLocalizedDescriptionKey] = @"The file specified for this response (%@) could not be read. Please double-check that you are using a valid file path.";
            userInfo[NSUnderlyingErrorKey] = readingError;
            NSError *error = [NSError errorWithDomain:@"com.mutualmobile.barricade" code:MMBarricadeErrorFileReading userInfo:userInfo];
            return [self responseWithName:name error:error];
        }
        else {
            return [self responseWithName:name data:data statusCode:statusCode headers:headers];
        }
    }
}

+ (instancetype)responseWithName:(NSString *)name
                            file:(NSString *)filePath
                      statusCode:(NSInteger)statusCode
                     contentType:(NSString *)contentType {
    
    NSDictionary *headers = [self headersWithContentType:contentType];
    return [self responseWithName:name file:filePath statusCode:statusCode headers:headers];
}


#pragma mark Data

+ (instancetype)responseWithName:(NSString *)name
                            data:(NSData *)data
                      statusCode:(NSInteger)statusCode
                         headers:(NSDictionary *)headers {

    MMBarricadeResponse *response = [[[self class] alloc] init];
    response.name = name;
    response.contentData = data;
    response.statusCode = statusCode;
    response.allHeaderFields = headers;
    return response;
}

+ (instancetype)responseWithName:(NSString *)name
                            data:(NSData *)data
                      statusCode:(NSInteger)statusCode
                     contentType:(NSString *)contentType {
    
    NSDictionary *headers = [self headersWithContentType:contentType];
    return [self responseWithName:name data:data statusCode:statusCode headers:headers];
}


#pragma mark - Private

+ (NSDictionary *)headersWithContentType:(NSString *)contentType {
    if (contentType.length > 0) {
        return @{MMBarricadeContentTypeHeaderKey: contentType};
    }
    return nil;
}

@end
