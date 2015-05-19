//
//  MMBarricadeResponseSetTests.m
//  Barricade
//
//  Created by John McIntosh on 5/12/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "MMBarricadeResponseSet.h"


@interface MMBarricadeResponseSetTests : XCTestCase

@end


@implementation MMBarricadeResponseSetTests

- (void)testCanCreateAResponseSet {
    MMBarricadeResponseSet *set = [[MMBarricadeResponseSet alloc] initWithRequestName:@"login" respondsToRequest:nil];
    XCTAssertEqualObjects(set.requestName, @"login");
}

- (void)testCanAddResponses {
    MMBarricadeResponseSet *set = [[MMBarricadeResponseSet alloc] initWithRequestName:@"login" respondsToRequest:nil];
    [set addResponse:[self sampleResponse]];
    [set addResponse:[self sampleResponse]];
    
    XCTAssertEqual(set.allResponses.count, 2);
}

- (void)testCanCreateResponseWithBlock {
    MMBarricadeResponseSet *set = [[MMBarricadeResponseSet alloc] initWithRequestName:@"login" respondsToRequest:nil];
    [set createResponseWithBlock:^id<MMBarricadeResponse>{
        MMBarricadeResponse *response = [[MMBarricadeResponse alloc] init];
        response.name = @"success";
        return response;
    }];
    XCTAssertEqual(set.allResponses.count, 1);
}

- (void)testCanPopulateResponseWithPopulationBlock {
    MMBarricadeResponseSet *set = [[MMBarricadeResponseSet alloc] initWithRequestName:@"login" respondsToRequest:nil];
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
    
    MMBarricadeResponseSet *set = [[MMBarricadeResponseSet alloc] initWithRequestName:@"login" respondsToRequest:nil];
    [set addResponse:response1];
    [set addResponse:response2];
    
    XCTAssertEqual(set.defaultResponse, response1);
}

- (void)testCanAdjustDefaultResponse {
    id<MMBarricadeResponse> response1 = [self sampleResponse];
    id<MMBarricadeResponse> response2 = [self sampleResponse];
    
    MMBarricadeResponseSet *set = [[MMBarricadeResponseSet alloc] initWithRequestName:@"login" respondsToRequest:nil];
    [set addResponse:response1];
    [set addResponse:response2];
    
    set.defaultResponse = response2;
    XCTAssertEqual(set.defaultResponse, response2);
}

- (void)testCannotSetDefaultResponseToAResponseNotInTheSet {
    id<MMBarricadeResponse> response1 = [self sampleResponse];
    id<MMBarricadeResponse> response2 = [self sampleResponse];
    id<MMBarricadeResponse> response3 = [self sampleResponse];
    
    MMBarricadeResponseSet *set = [[MMBarricadeResponseSet alloc] initWithRequestName:@"login" respondsToRequest:nil];
    [set addResponse:response1];
    [set addResponse:response2];
    
    set.defaultResponse = response3;
    XCTAssertEqual(set.defaultResponse, response1);
}

- (void)testUpdatingAllResponsesClearsDefaultResponse_ifDefaultResponseNotInNewSet {
    id<MMBarricadeResponse> response1 = [self sampleResponse];
    id<MMBarricadeResponse> response2 = [self sampleResponse];
    
    MMBarricadeResponseSet *set = [[MMBarricadeResponseSet alloc] initWithRequestName:@"login" respondsToRequest:nil];
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
    
    MMBarricadeResponseSet *set = [[MMBarricadeResponseSet alloc] initWithRequestName:@"login" respondsToRequest:nil];
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

@end
