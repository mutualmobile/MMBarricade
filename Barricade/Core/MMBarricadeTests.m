//
//  MMBarricadeTests.m
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
#import "MMBarricade.h"


@interface MMBarricadeTests : XCTestCase

@end


@implementation MMBarricadeTests

- (void)setUp {
    [super setUp];
    [MMBarricade setupWithInMemoryResponseStore];
    [MMBarricade enable];
}

- (void)tearDown {
    [MMBarricade disable];
    [super tearDown];
}


#pragma mark Core Tests

- (void)testCanMakeSuccessfulURLRequest_NSURLConnection {
    [MMBarricade registerResponseSet:[self loginResponseSet]];

    NSURL *URL = [NSURL URLWithString:@"http://example.com/login"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"request completed"];
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *URLResponse, NSData *data, NSError *connectionError) {

         NSHTTPURLResponse *response = (NSHTTPURLResponse *)URLResponse;
         XCTAssertEqual(response.statusCode, 200);
         XCTAssertEqualObjects(response.allHeaderFields[MMBarricadeContentTypeHeaderKey], @"application/json");
         XCTAssertEqualObjects(response.allHeaderFields[@"field"], @"value-success");
         
         id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         XCTAssertEqualObjects(JSON[@"userID"], @(1234));

         [completionExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testCanMakeSuccessfulURLRequest_NSURLSession_sharedSession {
    [MMBarricade registerResponseSet:[self loginResponseSet]];
    NSURL *URL = [NSURL URLWithString:@"http://example.com/login"];
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"request completed"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *URLResponse, NSError *error) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)URLResponse;
        XCTAssertEqual(response.statusCode, 200);
        XCTAssertEqualObjects(response.allHeaderFields[MMBarricadeContentTypeHeaderKey], @"application/json");
        XCTAssertEqualObjects(response.allHeaderFields[@"field"], @"value-success");
        
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        XCTAssertEqualObjects(JSON[@"userID"], @(1234));

        [completionExpectation fulfill];
    }];
    [task resume];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)testCanMakeSuccessfulURLRequest_NSURLSession_defaultSessionConfiguration {
    [MMBarricade registerResponseSet:[self loginResponseSet]];
    NSURL *URL = [NSURL URLWithString:@"http://example.com/login"];
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"request completed"];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    [MMBarricade disable];
    [MMBarricade enableForSessionConfiguration:configuration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *URLResponse, NSError *error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)URLResponse;
        XCTAssertEqual(response.statusCode, 200);
        XCTAssertEqualObjects(response.allHeaderFields[MMBarricadeContentTypeHeaderKey], @"application/json");
        XCTAssertEqualObjects(response.allHeaderFields[@"field"], @"value-success");
        
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        XCTAssertEqualObjects(JSON[@"userID"], @(1234));
        
        [completionExpectation fulfill];
    }];
    [task resume];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)testCanMakeSuccessfulURLRequest_NSURLSession_ephemeralSessionConfiguration {
    [MMBarricade registerResponseSet:[self loginResponseSet]];
    NSURL *URL = [NSURL URLWithString:@"http://example.com/login"];
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"request completed"];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    [MMBarricade disable];
    [MMBarricade enableForSessionConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *URLResponse, NSError *error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)URLResponse;
        XCTAssertEqual(response.statusCode, 200);
        XCTAssertEqualObjects(response.allHeaderFields[MMBarricadeContentTypeHeaderKey], @"application/json");
        XCTAssertEqualObjects(response.allHeaderFields[@"field"], @"value-success");
        
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        XCTAssertEqualObjects(JSON[@"userID"], @(1234));

        [completionExpectation fulfill];
    }];
    [task resume];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)testCanDisableBarricading_sharedSession {
    [MMBarricade registerResponseSet:[self loginResponseSet]];
    NSURL *URL = [NSURL URLWithString:@"mmbarricade://example/login"];
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"request completed"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *URLResponse, NSError *error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)URLResponse;
        XCTAssertEqual(response.statusCode, 200);
        XCTAssertEqualObjects(response.allHeaderFields[@"field"], @"value-success");

        [MMBarricade disable];
        NSURLSessionDataTask *internalTask = [session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *URLResponse, NSError *error) {
            
            XCTAssertNotNil(error);
            
            [completionExpectation fulfill];
        }];
        [internalTask resume];
    }];
    [task resume];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)testCanDisableBarricading_defaultSession {
    [MMBarricade registerResponseSet:[self loginResponseSet]];
    NSURL *URL = [NSURL URLWithString:@"mmbarricade://example/login"];
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"request completed"];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];

    [MMBarricade disable];
    [MMBarricade enableForSessionConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *URLResponse, NSError *error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)URLResponse;
        XCTAssertEqual(response.statusCode, 200);
        XCTAssertEqualObjects(response.allHeaderFields[@"field"], @"value-success");
        
        [MMBarricade disableForSessionConfiguration:session.configuration];
        NSURLSessionDataTask *internalTask = [session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *URLResponse, NSError *error) {
            
            XCTAssertNotNil(error);
            
            [completionExpectation fulfill];
        }];
        [internalTask resume];
    }];
    [task resume];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)testCanUnregisterResponseSets {
    MMBarricadeResponseSet *set = [self loginResponseSet];
    [MMBarricade registerResponseSet:set];
    [self
     executeRequestForURLString:@"http://example.com/login"
     withCompletionBlock:^(NSURLResponse *URLResponse, NSData *data, NSError *connectionError) {
         XCTAssertNil(connectionError);
     }];
    [MMBarricade unregisterResponseSet:set];
    [self
     executeRequestForURLString:@"http://example.com/login"
     withCompletionBlock:^(NSURLResponse *URLResponse, NSData *data, NSError *connectionError) {
         XCTAssertNotNil(connectionError);
     }];
}


#pragma mark Response Modification

- (void)testCanModifyExpectedURLRequest {
    [MMBarricade registerResponseSet:[self loginResponseSet]];
    [MMBarricade selectResponseForRequest:@"Login" withName:@"Service Unavailable"];
    [self
     executeRequestForURLString:@"http://example.com/login"
     withCompletionBlock:^(NSURLResponse *URLResponse, NSData *data, NSError *connectionError) {
         
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)URLResponse;
         XCTAssertEqual(response.statusCode, 503);
         XCTAssertEqualObjects(response.allHeaderFields[MMBarricadeContentTypeHeaderKey], @"application/json");
         XCTAssertEqualObjects(response.allHeaderFields[@"field"], @"value-failure");
         
         id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         XCTAssertEqualObjects(JSON[@"error"], @"The service is temporarily unavailable.");
     }];
}

- (void)testResponseCanReturnCustomError {
    [MMBarricade registerResponseSet:[self loginResponseSet]];
    [MMBarricade selectResponseForRequest:@"Login" withName:@"Network Offline"];
    [self
     executeRequestForURLString:@"http://example.com/login"
     withCompletionBlock:^(NSURLResponse *URLResponse, NSData *data, NSError *connectionError) {
         
         XCTAssertEqualObjects(connectionError.domain, NSURLErrorDomain);
         XCTAssertEqual(connectionError.code, NSURLErrorNotConnectedToInternet);
     }];
}

- (void)testRequestWithoutRegisteredResponseReturnsError {
    [MMBarricade setAllRequestsBarricaded:YES];
    [self
     executeRequestForURLString:@"http://example.com"
     withCompletionBlock:^(NSURLResponse *URLResponse, NSData *data, NSError *connectionError) {
         XCTAssertEqual(connectionError.code, MMBarricadeErrorNoRegisteredResponse);
         XCTAssertEqualObjects(connectionError.domain, @"com.mutualmobile.barricade");
     }];
}

- (void)testRequestWithoutRegisteredResponsePassesThroughWhenBarricadeIsPorus {
    NSURL *URL = [NSURL URLWithString:@"http://example.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];

    [MMBarricade setAllRequestsBarricaded:NO];
    XCTAssertFalse([MMBarricade canInitWithRequest:request]);
}


#pragma mark Response Delays

- (void)testDefaultResponseDelayIsZero {
    [MMBarricade registerResponseSet:[self loginResponseSet]];

    NSURL *URL = [NSURL URLWithString:@"http://example.com/login"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"request completed"];
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *URLResponse, NSData *data, NSError *connectionError) {
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)URLResponse;
         XCTAssertEqual(response.statusCode, 200);
         [completionExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:0.05 handler:nil];
}

- (void)testResponseDelayCanBeAdjusted {
    [MMBarricade setResponseDelay:0.5];
    [MMBarricade registerResponseSet:[self loginResponseSet]];
    
    NSURL *URL = [NSURL URLWithString:@"http://example.com/login"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSDate *requestStartDate = [NSDate date];
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"request completed"];
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *URLResponse, NSData *data, NSError *connectionError) {
         NSDate *requestEndDate = [NSDate date];
         NSTimeInterval requestDuration = [requestEndDate timeIntervalSinceDate:requestStartDate];
         XCTAssertTrue(requestDuration >= 0.5);
         
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)URLResponse;
         XCTAssertEqual(response.statusCode, 200);

         [completionExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:0.6 handler:nil];
}

- (void)testDelayedResponseCanBeCanceled {
    [MMBarricade setResponseDelay:0.5];
    [MMBarricade registerResponseSet:[self loginResponseSet]];
    
    NSURL *URL = [NSURL URLWithString:@"http://example.com/login"];

    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"request completed"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertEqualObjects(error.domain, @"NSURLErrorDomain");
        XCTAssertEqual(error.code, NSURLErrorCancelled);
        [completionExpectation fulfill];
    }];
    [task resume];
    [task cancel];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}


#pragma mark Convenience Methods

- (void)testConvenienceStubbingOfSingleRequest {
    [MMBarricade stubRequestsPassingTest:^BOOL(NSURLRequest *request, NSURLComponents *components) {
        return [components.path isEqualToString:@"/login"];
    } withResponse:^id<MMBarricadeResponse>(NSURLRequest *request) {
        MMBarricadeResponse *data = [[MMBarricadeResponse alloc] init];
        data.contentType = @"application/json";
        data.statusCode = 200;
        data.contentString = @"{\"userID\":1234}";
        data.allHeaderFields = @{@"field":  @"value-success"};
        return data;
    }];

    [self
     executeRequestForURLString:@"http://example.com/login"
     withCompletionBlock:^(NSURLResponse *URLResponse, NSData *data, NSError *connectionError) {
         
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)URLResponse;
         XCTAssertEqual(response.statusCode, 200);
         XCTAssertEqualObjects(response.allHeaderFields[MMBarricadeContentTypeHeaderKey], @"application/json");
         XCTAssertEqualObjects(response.allHeaderFields[@"field"], @"value-success");
         
         id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         XCTAssertEqualObjects(JSON[@"userID"], @(1234));
     }];
}


#pragma mark - Private

- (void)executeRequestForURLString:(NSString *)URLString
               withCompletionBlock:(void(^)(NSURLResponse *URLResponse, NSData *data, NSError *connectionError))completionBlock {
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];

    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"request completed"];
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *URLResponse, NSData *data, NSError *connectionError) {
         if (completionBlock) completionBlock(URLResponse, data, connectionError);
         [completionExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (MMBarricadeResponseSet *)loginResponseSet {
    MMBarricadeResponse *successfulResponse = [[MMBarricadeResponse alloc] init];
    successfulResponse.name = @"Success";
    successfulResponse.contentType = @"application/json";
    successfulResponse.statusCode = 200;
    successfulResponse.contentString = @"{\"userID\":1234}";
    successfulResponse.allHeaderFields = @{@"field":  @"value-success"};
    
    MMBarricadeResponse *failureResponse = [[MMBarricadeResponse alloc] init];
    failureResponse.name = @"Service Unavailable";
    failureResponse.contentType = @"application/json";
    failureResponse.statusCode = 503;
    failureResponse.contentString = @"{\"error\":\"The service is temporarily unavailable.\"}";
    failureResponse.allHeaderFields = @{@"field":  @"value-failure"};

    MMBarricadeResponse *offlineResponse = [[MMBarricadeResponse alloc] init];
    offlineResponse.name = @"Network Offline";
    offlineResponse.error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil];

    MMBarricadeResponseSet *responseSet = [[MMBarricadeResponseSet alloc] initWithRequestName:@"Login" respondsToRequest:^BOOL(NSURLRequest *request, NSURLComponents *components) {
        return [components.path isEqualToString:@"/login"];
    }];
    [responseSet addResponse:successfulResponse];
    [responseSet addResponse:failureResponse];
    [responseSet addResponse:offlineResponse];
    
    return responseSet;
}

@end
