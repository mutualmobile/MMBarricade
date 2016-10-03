//
//  MMBarricadeResponseSetTests.m
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
#import "OCMock.h"
#import "MMBarricadeResponseSet.h"


@interface MMBarricadeResponseSetTests : XCTestCase

@end


@implementation MMBarricadeResponseSetTests

- (void)testCanCreateAResponseSet {
    MMBarricadeResponseSet *set = [self stubResponseSetWithName:@"login"];
    XCTAssertEqualObjects(set.requestName, @"login");
}

- (void)testCanAddResponses {
    MMBarricadeResponseSet *set = [self stubResponseSetWithName:@"login"];
    [set addResponse:[self sampleResponse]];
    [set addResponse:[self sampleResponse]];
    
    XCTAssertEqual(set.allResponses.count, 2);
}

- (void)testCanCreateResponseWithBlock {
    MMBarricadeResponseSet *set = [self stubResponseSetWithName:@"login"];
    [set createResponseWithBlock:^id<MMBarricadeResponse>{
        MMBarricadeResponse *response = [[MMBarricadeResponse alloc] init];
        response.name = @"success";
        return response;
    }];
    XCTAssertEqual(set.allResponses.count, 1);
}

- (void)testCanPopulateResponseWithPopulationBlock {
    MMBarricadeResponseSet *set = [self stubResponseSetWithName:@"login"];
    [set createResponseWithName:@"success" populationBlock:^(MMBarricadeResponse *response) {
        response.statusCode = 200;
        response.contentString = @"response body";
    }];
    
    id<MMBarricadeResponse> response = [set responseWithName:@"success"];
    XCTAssertEqualObjects(response.contentData, [@"response body" dataUsingEncoding:NSUTF8StringEncoding]);
    XCTAssertEqual(response.statusCode, 200);
}


#pragma mark Default Response

- (void)testDefaultResponseDefaultsToFirstItemAdded {
    id<MMBarricadeResponse> response1 = [self sampleResponse];
    id<MMBarricadeResponse> response2 = [self sampleResponse];
    
    MMBarricadeResponseSet *set = [self stubResponseSetWithName:@"login"];
    [set addResponse:response1];
    [set addResponse:response2];
    
    XCTAssertEqual(set.defaultResponse, response1);
}

- (void)testCanAdjustDefaultResponse {
    id<MMBarricadeResponse> response1 = [self sampleResponse];
    id<MMBarricadeResponse> response2 = [self sampleResponse];
    
    MMBarricadeResponseSet *set = [self stubResponseSetWithName:@"login"];
    [set addResponse:response1];
    [set addResponse:response2];
    
    set.defaultResponse = response2;
    XCTAssertEqual(set.defaultResponse, response2);
}

- (void)testCannotSetDefaultResponseToAResponseNotInTheSet {
    id<MMBarricadeResponse> response1 = [self sampleResponse];
    id<MMBarricadeResponse> response2 = [self sampleResponse];
    id<MMBarricadeResponse> response3 = [self sampleResponse];
    
    MMBarricadeResponseSet *set = [self stubResponseSetWithName:@"login"];
    [set addResponse:response1];
    [set addResponse:response2];
    
    set.defaultResponse = response3;
    XCTAssertEqual(set.defaultResponse, response1);
}

- (void)testUpdatingAllResponsesClearsDefaultResponse_ifDefaultResponseNotInNewSet {
    id<MMBarricadeResponse> response1 = [self sampleResponse];
    id<MMBarricadeResponse> response2 = [self sampleResponse];
    
    MMBarricadeResponseSet *set = [self stubResponseSetWithName:@"login"];
    [set addResponse:response1];
    [set addResponse:response2];
    set.defaultResponse = response2;
    
    id<MMBarricadeResponse> response3 = [self sampleResponse];
    id<MMBarricadeResponse> response4 = [self sampleResponse];
    set.allResponses = @[response3, response4];
    
    XCTAssertEqual(set.defaultResponse, response3);
}

- (void)testUpdatingAllResponsesMaintainsDefaultResponse_ifDefaultResponseInNewSet {
    id<MMBarricadeResponse> response1 = [self sampleResponse];
    id<MMBarricadeResponse> response2 = [self sampleResponse];
    id<MMBarricadeResponse> response3 = [self sampleResponse];
    id<MMBarricadeResponse> response4 = [self sampleResponse];
    
    MMBarricadeResponseSet *set = [self stubResponseSetWithName:@"login"];
    [set addResponse:response1];
    [set addResponse:response2];
    set.defaultResponse = response2;
    
    set.allResponses = @[response1, response2, response3, response4];
    
    XCTAssertEqual(set.defaultResponse, response2);
}


#pragma mark - Private

- (id<MMBarricadeResponse>)sampleResponse {
    id response = OCMProtocolMock(@protocol(MMBarricadeResponse));
    OCMStub([response name]).andReturn(@"sample response");
    OCMStub([response responseForRequest]).andReturn(nil);
    return response;
}

- (MMBarricadeResponseSet *)stubResponseSetWithName:(NSString *)name {
    return [MMBarricadeResponseSet
            responseSetForRequestName:name
            respondsToRequest:^BOOL(NSURLRequest * _Nonnull request, NSURLComponents * _Nonnull components) {
                return YES;
            }];
}

@end
