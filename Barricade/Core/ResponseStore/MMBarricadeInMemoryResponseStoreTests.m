//
//  MMBarricadeInMemoryResponseStoreTests.m
//  Barricade
//
//  Created by John McIntosh on 5/12/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "MMBarricadeInMemoryResponseStore.h"


@interface MMBarricadeInMemoryResponseStoreTests : XCTestCase

@property (nonatomic, strong) id<MMBarricadeResponseStore> responseStore;

@end


@implementation MMBarricadeInMemoryResponseStoreTests

- (void)setUp {
    [super setUp];
    self.responseStore = [[MMBarricadeInMemoryResponseStore alloc] init];
}

- (void)tearDown {
    self.responseStore = nil;
    [super tearDown];
}


#pragma mark - Registration

- (void)testCanRegisterSingleResponseSet {
    [self.responseStore registerResponseSet:[self movieListResponseSet]];
    XCTAssertEqual(self.responseStore.allResponseSets.count, 1);
}

- (void)testResponseSetOrderMatchesRegistrationOrder {
    MMBarricadeResponseSet *movieSet = [self movieListResponseSet];
    MMBarricadeResponseSet *loginSet = [self loginResponseSet];
    
    [self.responseStore registerResponseSet:movieSet];
    [self.responseStore registerResponseSet:loginSet];
    
    NSArray *responseSets = self.responseStore.allResponseSets;
    XCTAssertEqual(responseSets.count, 2);
    XCTAssertEqualObjects(responseSets[0], movieSet);
    XCTAssertEqualObjects(responseSets[1], loginSet);
}


#pragma mark - Current Response Management

- (void)testCurrentResponseDefaultsToDefaultResponse {
    MMBarricadeResponseSet *loginSet = [self loginResponseSet];
    [self.responseStore registerResponseSet:loginSet];
    
    id<MMBarricadeResponse> response = [self.responseStore currentResponseForResponseSet:loginSet];
    XCTAssertEqualObjects(response.name, @"success");
}

- (void)testCurrentResponseCanBeUpdated {
    MMBarricadeResponseSet *loginSet = [self loginResponseSet];
    [self.responseStore registerResponseSet:loginSet];
    [self.responseStore selectCurrentResponseForResponseSet:loginSet withName:@"failure"];
    
    id<MMBarricadeResponse> response = [self.responseStore currentResponseForResponseSet:loginSet];
    XCTAssertEqualObjects(response.name, @"failure");
}

- (void)testCurrentResponseCanBeResetToDefault {
    MMBarricadeResponseSet *loginSet = [self loginResponseSet];
    [self.responseStore registerResponseSet:loginSet];
    [self.responseStore selectCurrentResponseForResponseSet:loginSet withName:@"failure"];
    
    id<MMBarricadeResponse> response = [self.responseStore currentResponseForResponseSet:loginSet];
    XCTAssertEqualObjects(response.name, @"failure");
    
    [self.responseStore resetResponseSelections];
    response = [self.responseStore currentResponseForResponseSet:loginSet];
    XCTAssertEqualObjects(response.name, @"success");
}


#pragma mark - Private

- (MMBarricadeResponseSet *)movieListResponseSet {
    id<MMBarricadeResponse> successfulResponse = OCMProtocolMock(@protocol(MMBarricadeResponse));
    OCMStub([successfulResponse name]).andReturn(@"success");
    
    id<MMBarricadeResponse> failureResponse = OCMProtocolMock(@protocol(MMBarricadeResponse));
    OCMStub([failureResponse name]).andReturn(@"failure");

    MMBarricadeResponseSet *responseSet = [[MMBarricadeResponseSet alloc] initWithRequestName:@"Movie List" respondsToRequest:^BOOL(NSURLRequest *request, NSURLComponents *URLComponents) {
        return [URLComponents.path isEqualToString:@"/movies"];
    }];

    [responseSet addResponse:successfulResponse];
    [responseSet addResponse:failureResponse];
    
    return responseSet;
}

- (MMBarricadeResponseSet *)loginResponseSet {
    id successfulResponse = OCMProtocolMock(@protocol(MMBarricadeResponse));
    OCMStub([successfulResponse name]).andReturn(@"success");
    
    id<MMBarricadeResponse> failureResponse = OCMProtocolMock(@protocol(MMBarricadeResponse));
    OCMStub([failureResponse name]).andReturn(@"failure");

    MMBarricadeResponseSet *responseSet = [[MMBarricadeResponseSet alloc] initWithRequestName:@"Login" respondsToRequest:^BOOL(NSURLRequest *request, NSURLComponents *URLComponents) {
        return [URLComponents.path isEqualToString:@"/login"];
    }];

    [responseSet addResponse:successfulResponse];
    [responseSet addResponse:failureResponse];
    
    return responseSet;
}
@end
