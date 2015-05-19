//
//  MMBarricadeTweaksResponseStoreTests.m
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
#import "MMBarricadeTweaksResponseStore.h"
#import "MMBarricadeResponseSet.h"


@interface MMBarricadeTweaksResponseStoreTests : XCTestCase

@property (nonatomic, strong) id<MMBarricadeResponseStore> responseStore;

@end


@implementation MMBarricadeTweaksResponseStoreTests

- (void)setUp {
    [super setUp];
    self.responseStore = [[MMBarricadeTweaksResponseStore alloc] init];
    [self.responseStore resetResponseSelections];
}

- (void)tearDown {
    self.responseStore = nil;
    [super tearDown];
}


#pragma mark - Registration

- (void)testCanRegisterSingleResponseSet {
    MMBarricadeResponseSet *responseSet = [self movieListResponseSet];
    [self.responseStore registerResponseSet:responseSet];
    
    NSArray *allSets = self.responseStore.allResponseSets;
    XCTAssertEqual(allSets.count, 1);
    XCTAssertEqual(allSets[0], responseSet);
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
    MMBarricadeResponse *successfulResponse = [[MMBarricadeResponse alloc] init];
    successfulResponse.name = @"success";

    MMBarricadeResponse *failureResponse = [[MMBarricadeResponse alloc] init];
    failureResponse.name = @"failure";
    
    MMBarricadeResponseSet *responseSet = [[MMBarricadeResponseSet alloc] initWithRequestName:@"Movie List" respondsToRequest:^BOOL(NSURLRequest *request, NSURLComponents *components) {
        return [components.path isEqualToString:@"/movies"];
    }];
    [responseSet addResponse:successfulResponse];
    [responseSet addResponse:failureResponse];
    
    return responseSet;
}

- (MMBarricadeResponseSet *)loginResponseSet {
    MMBarricadeResponse *successfulResponse = [[MMBarricadeResponse alloc] init];
    successfulResponse.name = @"success";
    
    MMBarricadeResponse *failureResponse = [[MMBarricadeResponse alloc] init];
    failureResponse.name = @"failure";
    
    MMBarricadeResponseSet *responseSet = [[MMBarricadeResponseSet alloc] initWithRequestName:@"Login" respondsToRequest:^BOOL(NSURLRequest *request, NSURLComponents *components) {
        return [components.path isEqualToString:@"/login"];
    }];
    [responseSet addResponse:successfulResponse];
    [responseSet addResponse:failureResponse];
    
    return responseSet;
}

@end
