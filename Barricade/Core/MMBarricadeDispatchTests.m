//
//  MMBarricadeDispatchTests.m
//  Barricade
//
//  Created by John McIntosh on 5/13/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "MMBarricadeDispatch.h"
#import "MMBarricadeResponseSet.h"
#import "MMBarricadeInMemoryResponseStore.h"


@interface MMBarricadeDispatchTests : XCTestCase

@end


@implementation MMBarricadeDispatchTests

- (void)testCannotCreateDispatchWithNilResponseStore {
    MMBarricadeDispatch *dispatch = [[MMBarricadeDispatch alloc] initWithResponseStore:nil];
    XCTAssertNil(dispatch);
}


#pragma mark - Basic vending of responses for requests

- (void)testRequestWithNoDispatchResponsesReturnsNil {
    MMBarricadeDispatch *dispatch = [self dispatchWithInMemoryStore];
    
    NSURLRequest *request = [self movieListRequest];
    id<MMBarricadeResponse> response = [dispatch responseForRequest:request];
    
    XCTAssertNil(response);
}

- (void)testRequestWithoutRegisteredResponseReturnsNil {
    MMBarricadeDispatch *dispatch = [self dispatchWithInMemoryStore];
    [dispatch registerResponseSet:[self movieListResponseSet]];
    
    NSURLRequest *request = [self nonRegisteredRequest];
    id<MMBarricadeResponse> response = [dispatch responseForRequest:request];
    
    XCTAssertNil(response);
}

- (void)testCurrentResponseDefaultsToDefaultResponse {
    MMBarricadeDispatch *dispatch = [self dispatchWithInMemoryStore];
    [dispatch registerResponseSet:[self movieListResponseSet]];

    NSURLRequest *request = [self movieListRequest];
    id<MMBarricadeResponse> response = [dispatch responseForRequest:request];
    
    XCTAssertEqualObjects(response.name, @"Success");
}


#pragma mark Current Response

- (void)testCurrentResponseCanBeUpdated {
    MMBarricadeDispatch *dispatch = [self dispatchWithInMemoryStore];
    [dispatch registerResponseSet:[self movieListResponseSet]];
    [dispatch selectResponseforRequest:@"Movie List" withResponseName:@"Service Unavailable"];

    NSURLRequest *request = [self movieListRequest];
    id<MMBarricadeResponse> response = [dispatch responseForRequest:request];
    
    XCTAssertEqualObjects(response.name, @"Service Unavailable");
}

- (void)testCannotSetCurrentResponseToAResponseNotInTheSet {
    MMBarricadeDispatch *dispatch = [self dispatchWithInMemoryStore];
    [dispatch registerResponseSet:[self movieListResponseSet]];
    [dispatch selectResponseforRequest:@"Movie List" withResponseName:@"Nonexistent Response"];

    NSURLRequest *request = [self movieListRequest];
    id<MMBarricadeResponse> response = [dispatch responseForRequest:request];

    XCTAssertEqualObjects(response.name, @"Success");
}

- (void)testAbilityToResetUpdatedResponses {
    MMBarricadeDispatch *dispatch = [self dispatchWithInMemoryStore];
    [dispatch registerResponseSet:[self movieListResponseSet]];
    [dispatch selectResponseforRequest:@"Movie List" withResponseName:@"Service Unavailable"];

    NSURLRequest *request = [self movieListRequest];
    id<MMBarricadeResponse> response = [dispatch responseForRequest:request];
    XCTAssertEqualObjects(response.name, @"Service Unavailable");
    
    [dispatch resetResponseSelections];
    response = [dispatch responseForRequest:request];
    XCTAssertEqualObjects(response.name, @"Success");
}


#pragma mark - Private

- (MMBarricadeDispatch *)dispatchWithInMemoryStore {
    id<MMBarricadeResponseStore> responseStore = [[MMBarricadeInMemoryResponseStore alloc] init];
    MMBarricadeDispatch *dispatch = [[MMBarricadeDispatch alloc] initWithResponseStore:responseStore];
    return dispatch;
}

- (MMBarricadeResponseSet *)movieListResponseSet {
    id successfulResponse = OCMProtocolMock(@protocol(MMBarricadeResponse));
    OCMStub([successfulResponse name]).andReturn(@"Success");

    id failureResponse = OCMProtocolMock(@protocol(MMBarricadeResponse));
    OCMStub([failureResponse name]).andReturn(@"Service Unavailable");

    MMBarricadeResponseSet *responseSet = [[MMBarricadeResponseSet alloc] initWithRequestName:@"Movie List" respondsToRequest:^BOOL(NSURLRequest *request, NSURLComponents *components) {
        return [components.path isEqualToString:@"/movies"];
    }];
    [responseSet addResponse:successfulResponse];
    [responseSet addResponse:failureResponse];
    
    return responseSet;
}

- (NSURLRequest *)movieListRequest {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://example.com/movies"]];
    return request;
}

- (NSURLRequest *)nonRegisteredRequest {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://example.com"]];
    return request;
}

@end
