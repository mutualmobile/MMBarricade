//
//  MMBarricadeDispatchTests.m
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
#import "MMBarricadeDispatch.h"
#import "MMBarricadeResponseSet.h"
#import "MMBarricadeInMemoryResponseStore.h"


@interface MMBarricadeDispatchTests : XCTestCase

@end


@implementation MMBarricadeDispatchTests

- (void)testCannotCreateDispatchWithNilResponseStore {
    // Intentionally testing passing null to a callee that requires nonnull. Suppress the warning.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    MMBarricadeDispatch *dispatch = [[MMBarricadeDispatch alloc] initWithResponseStore:nil];
    XCTAssertNil(dispatch);
#pragma clang diagnostic pop
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


#pragma mark Unregistration

- (void)testCanUnregisterResponseSets {
    MMBarricadeDispatch *dispatch = [self dispatchWithInMemoryStore];

    MMBarricadeResponseSet *movieSet = [self movieListResponseSet];
    MMBarricadeResponseSet *loginSet = [self loginResponseSet];
    [dispatch registerResponseSet:movieSet];
    [dispatch registerResponseSet:loginSet];

    NSURLRequest *movieRequest = [self movieListRequest];
    id<MMBarricadeResponse> response = [dispatch responseForRequest:movieRequest];
    XCTAssertNotNil(response);

    [dispatch unregisterResponseSet:movieSet];
    response = [dispatch responseForRequest:movieRequest];
    XCTAssertNil(response);

    response = [dispatch responseForRequest:[self loginRequest]];
    XCTAssertNotNil(response);
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

- (MMBarricadeResponseSet *)loginResponseSet {
    id successfulResponse = OCMProtocolMock(@protocol(MMBarricadeResponse));
    OCMStub([successfulResponse name]).andReturn(@"Success");
    
    id failureResponse = OCMProtocolMock(@protocol(MMBarricadeResponse));
    OCMStub([failureResponse name]).andReturn(@"Service Unavailable");
    
    MMBarricadeResponseSet *responseSet = [[MMBarricadeResponseSet alloc] initWithRequestName:@"Login" respondsToRequest:^BOOL(NSURLRequest *request, NSURLComponents *components) {
        return [components.path isEqualToString:@"/login"];
    }];
    [responseSet addResponse:successfulResponse];
    [responseSet addResponse:failureResponse];
    
    return responseSet;
}

- (NSURLRequest *)movieListRequest {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://example.com/movies"]];
    return request;
}

- (NSURLRequest *)loginRequest {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://example.com/login"]];
    return request;
}

- (NSURLRequest *)nonRegisteredRequest {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://example.com"]];
    return request;
}

@end
