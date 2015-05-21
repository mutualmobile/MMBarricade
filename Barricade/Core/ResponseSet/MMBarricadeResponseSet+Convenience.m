//
//  MMBarricadeResponseSet+Convenience.m
//
// Copyright (c) 2015 Mutual Mobile (http://www.mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MMBarricadeResponseSet+Convenience.h"
#import "MMBarricadeResponse+Convenience.h"
#import "MMBarricadeErrors.h"


@implementation MMBarricadeResponseSet (Convenience)

#pragma mark Error

- (MMBarricadeResponse *)addResponseWithName:(NSString *)name error:(NSError *)error {
    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:name error:error];
    [self addResponse:response];
    return response;
}


#pragma mark JSON

- (MMBarricadeResponse *)addResponseWithName:(NSString *)name
                            JSON:(id)JSON
                      statusCode:(NSInteger)statusCode
                         headers:(NSDictionary *)headers {

    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:name JSON:JSON statusCode:statusCode headers:headers];
    [self addResponse:response];
    return response;
}

- (MMBarricadeResponse *)addResponseWithName:(NSString *)name
                            JSON:(id)JSON
                      statusCode:(NSInteger)statusCode
                     contentType:(NSString *)contentType {

    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:name JSON:JSON statusCode:statusCode contentType:contentType];
    [self addResponse:response];
    return response;
}


#pragma mark File

- (MMBarricadeResponse *)addResponseWithName:(NSString *)name
                            file:(NSString *)filePath
                      statusCode:(NSInteger)statusCode
                         headers:(NSDictionary *)headers {

    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:name file:filePath statusCode:statusCode headers:headers];
    [self addResponse:response];
    return response;
}

- (MMBarricadeResponse *)addResponseWithName:(NSString *)name
                            file:(NSString *)filePath
                      statusCode:(NSInteger)statusCode
                     contentType:(NSString *)contentType {
    
    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:name file:filePath statusCode:statusCode contentType:contentType];
    [self addResponse:response];
    return response;
}


#pragma mark Data

- (MMBarricadeResponse *)addResponseWithName:(NSString *)name
                            data:(NSData *)data
                      statusCode:(NSInteger)statusCode
                         headers:(NSDictionary *)headers {

    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:name data:data statusCode:statusCode headers:headers];
    [self addResponse:response];
    return response;
}

- (MMBarricadeResponse *)addResponseWithName:(NSString *)name
                            data:(NSData *)data
                      statusCode:(NSInteger)statusCode
                     contentType:(NSString *)contentType {

    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:name data:data statusCode:statusCode contentType:contentType];
    [self addResponse:response];
    return response;
}

@end
