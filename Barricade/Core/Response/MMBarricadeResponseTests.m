//
//  MMBarricadeResponseTests.m
//  Barricade
//
//  Created by John McIntosh on 5/14/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

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
