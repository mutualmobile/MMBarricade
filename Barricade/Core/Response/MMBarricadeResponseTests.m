//
//  MMBarricadeResponseTests.m
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
#import "MMBarricadeResponse.h"


@interface MMBarricadeResponseTests : XCTestCase

@end


@implementation MMBarricadeResponseTests


#pragma mark Content Type

- (void)testAllHeaderFieldsIncludesContentType_withNoOtherHeaders {
    MMBarricadeResponse *response = [[MMBarricadeResponse alloc] init];
    response.contentType = @"application/json";
    XCTAssertEqualObjects(response.allHeaderFields[MMBarricadeContentTypeHeaderKey], @"application/json");
}

- (void)testAllHeaderFieldsIncludesContentType_withAdditionalHeaders {
    MMBarricadeResponse *response = [[MMBarricadeResponse alloc] init];
    response.contentType = @"application/json";
    response.allHeaderFields = @{@"key": @"value"};
    XCTAssertEqualObjects(response.allHeaderFields[MMBarricadeContentTypeHeaderKey], @"application/json");
    XCTAssertEqualObjects(response.allHeaderFields[@"key"], @"value");
}

- (void)testAllContentTypeOverridesHeaderFields {
    MMBarricadeResponse *response = [[MMBarricadeResponse alloc] init];
    response.allHeaderFields = @{MMBarricadeContentTypeHeaderKey: @"text/plain"};
    response.contentType = @"application/json";
    XCTAssertEqualObjects(response.allHeaderFields[MMBarricadeContentTypeHeaderKey], @"application/json");
}

- (void)testClearingContentTypeClearsContentHeader {
    MMBarricadeResponse *response = [[MMBarricadeResponse alloc] init];
    response.contentType = @"application/json";
    XCTAssertEqualObjects(response.allHeaderFields[MMBarricadeContentTypeHeaderKey], @"application/json");
    response.contentType = nil;
    XCTAssertNil(response.allHeaderFields[MMBarricadeContentTypeHeaderKey]);
}


#pragma mark Content String/Data

- (void)testSettingContentStringSetsContentData {
    MMBarricadeResponse *response = [[MMBarricadeResponse alloc] init];
    response.contentString = @"Sample response string";
    XCTAssertEqualObjects(response.contentData, [@"Sample response string" dataUsingEncoding:NSUTF8StringEncoding]);
}

- (void)testSettingContentDataSetsContentString {
    MMBarricadeResponse *response = [[MMBarricadeResponse alloc] init];
    response.contentData = [@"Sample response string" dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(response.contentString, @"Sample response string");
}


#pragma mark Dynamic Responses

- (void)testDynamicResponseOverridesStandardResponse {
    MMBarricadeResponse *staticResponse = [[MMBarricadeResponse alloc] init];
    staticResponse.statusCode = 400;
    staticResponse.contentString = @"Static response string";
    [staticResponse setDynamicResponseForRequest:^id<MMBarricadeResponse>(NSURLRequest *request) {
        MMBarricadeResponse *dynamicResponse = [[MMBarricadeResponse alloc] init];
        dynamicResponse.statusCode = 200;
        dynamicResponse.contentString = @"Dynamic response string";
        return dynamicResponse;
    }];
    
    NSURL *URL = [NSURL URLWithString:@"http://example.com"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    id<MMBarricadeResponse> response = staticResponse.responseForRequest(request);
    XCTAssertEqual(response.statusCode, 200);
    XCTAssertEqualObjects(response.contentData, [@"Dynamic response string" dataUsingEncoding:NSUTF8StringEncoding]);
}

- (void)testDynamicResponseIsActuallyDynamic {
    MMBarricadeResponse *staticResponse = [[MMBarricadeResponse alloc] init];
    [staticResponse setDynamicResponseForRequest:^id<MMBarricadeResponse>(NSURLRequest *request) {
        MMBarricadeResponse *dynamicResponse = [[MMBarricadeResponse alloc] init];
        dynamicResponse.contentString = request.URL.absoluteString;
        return dynamicResponse;
    }];
    
    NSURL *URL = [NSURL URLWithString:@"http://example.com"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    id<MMBarricadeResponse> response = staticResponse.responseForRequest(request);
    XCTAssertEqualObjects(response.contentData, [@"http://example.com" dataUsingEncoding:NSUTF8StringEncoding]);
}


#pragma mark Debug Description

- (void)testDescriptionForErrorResponse {
    MMBarricadeResponse *response = [[MMBarricadeResponse alloc] init];
    response.error = [NSError errorWithDomain:@"com.mutualmobile.barricade" code:500 userInfo:nil];
    XCTAssertEqualObjects(response.debugDescription, @"<MMBarricadeResponse Error | Domain: com.mutualmobile.barricade | Code: 500>");
}

- (void)testDescriptionForStandardResponse {
    MMBarricadeResponse *response = [[MMBarricadeResponse alloc] init];
    response.statusCode = 200;
    response.name = @"success";
    response.allHeaderFields = @{
                                 MMBarricadeContentTypeHeaderKey: @"application/json",
                                 @"key": @"value",
                                 };
    XCTAssertEqualObjects(response.debugDescription, @"<MMBarricadeResponse 200 | success | 2 headers>");
}

@end
