//
//  MMBarricadeResponseConvenienceTests.m
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

#import <XCTest/XCTest.h>
#import "MMBarricadeResponse+Convenience.h"
#import "MMBarricadeErrors.h"


@interface MMBarricadeResponseConvenienceTests : XCTestCase

@end


@implementation MMBarricadeResponseConvenienceTests

#pragma mark Error

- (void)testErrorResponseCreation {
    NSError *error = [NSError errorWithDomain:@"com.mutualmobile.barricade" code:500 userInfo:@{NSLocalizedDescriptionKey: @"Test error"}];
    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:@"error" error:error];
    
    XCTAssertEqualObjects(response.error.domain, @"com.mutualmobile.barricade");
    XCTAssertEqual(response.error.code, 500);
    XCTAssertEqualObjects(response.error.userInfo[NSLocalizedDescriptionKey], @"Test error");
}


#pragma mark JSON

- (void)testJSONResponseCreation_headers {
    NSDictionary *JSON = @{@"key": @"value"};
    NSDictionary *headers = @{@"headerKey": @"headerValue"};
    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:@"success"
                                                                     JSON:JSON
                                                               statusCode:200
                                                                  headers:headers];
    
    XCTAssertEqual(response.statusCode, 200);
    NSData *data = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
    XCTAssertEqualObjects(response.contentData, data);
    XCTAssertEqualObjects(response.allHeaderFields[@"headerKey"], @"headerValue");
}

- (void)testJSONResponseCreation_contentType {
    NSDictionary *JSON = @{@"key": @"value"};
    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:@"success"
                                                                     JSON:JSON
                                                               statusCode:200
                                                              contentType:@"application/json"];
    
    XCTAssertEqual(response.statusCode, 200);
    NSData *data = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
    XCTAssertEqualObjects(response.contentData, data);
    XCTAssertEqualObjects(response.contentType, @"application/json");
}

- (void)testJSONResponseCreation_invalidJSON {
    id invalidJSON = @{@"key": [[NSObject alloc] init]};
    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:@"invalid"
                                                                     JSON:invalidJSON
                                                               statusCode:200
                                                                  headers:nil];
    
    XCTAssertEqualObjects(response.error.domain, @"com.mutualmobile.barricade");
    XCTAssertEqual(response.error.code, MMBarricadeErrorInvalidJSON);
}


#pragma mark File

- (void)testFileResponseCreation_headers {
    NSString *filename = @"file.response.txt";
    NSString *directory = @"LocalServerResources";
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filepath = [bundle pathForResource:filename ofType:nil inDirectory:directory];
    
    NSDictionary *headers = @{@"headerKey": @"headerValue"};
    
    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:@"success"
                                                                     file:filepath
                                                               statusCode:200
                                                                  headers:headers];
    
    XCTAssertEqual(response.statusCode, 200);
    XCTAssertEqualObjects(response.contentString, @"Sample file-based response.");
    XCTAssertEqualObjects(response.allHeaderFields[@"headerKey"], @"headerValue");
}

- (void)testFileResponseCreation_contentType {
    NSString *filename = @"file.response.txt";
    NSString *directory = @"LocalServerResources";
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filepath = [bundle pathForResource:filename ofType:nil inDirectory:directory];
    
    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:@"success"
                                                                     file:filepath
                                                               statusCode:200
                                                              contentType:@"application/json"];
    
    XCTAssertEqual(response.statusCode, 200);
    XCTAssertEqualObjects(response.contentString, @"Sample file-based response.");
    XCTAssertEqualObjects(response.contentType, @"application/json");
}

- (void)testFileResponseCreation_invalidFilepath {
    NSString *filename = @"missing.file.json";
    NSString *directory = @"NonexistentDirectory";
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filepath = [bundle pathForResource:filename ofType:nil inDirectory:directory];
    
    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:@"missing"
                                                                     file:filepath
                                                               statusCode:200
                                                                  headers:nil];
    
    XCTAssertEqualObjects(response.error.domain, @"com.mutualmobile.barricade");
    XCTAssertEqual(response.error.code, MMBarricadeErrorNilFilepath);
}


#pragma mark Data

- (void)testDataResponseCreation_headers {
    NSData *data = [@"Sample response string" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *headers = @{@"headerKey": @"headerValue"};
    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:@"success"
                                                                     data:data
                                                               statusCode:200
                                                                  headers:headers];
    
    XCTAssertEqual(response.statusCode, 200);
    XCTAssertEqualObjects(response.contentString, @"Sample response string");
    XCTAssertEqualObjects(response.allHeaderFields[@"headerKey"], @"headerValue");
}

- (void)testDataResponseCreation_contentType {
    NSData *data = [@"Sample response string" dataUsingEncoding:NSUTF8StringEncoding];
    MMBarricadeResponse *response = [MMBarricadeResponse responseWithName:@"success"
                                                                     data:data
                                                               statusCode:200
                                                              contentType:@"application/json"];
    
    XCTAssertEqual(response.statusCode, 200);
    XCTAssertEqualObjects(response.contentString, @"Sample response string");
    XCTAssertEqualObjects(response.contentType, @"application/json");
}

@end