//
//  MMBarricade.h
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

#import <Foundation/Foundation.h>
#import "MMBarricadeErrors.h"
#import "MMBarricadePathUtility.h"
#import "MMBarricadeResponse.h"
#import "MMBarricadeResponse+Convenience.h"
#import "MMBarricadeResponseSet.h"
#import "MMBarricadeResponseSet+Convenience.h"
#import "MMBarricadeResponseStore.h"


/**
 `MMBarricade` is a `NSURLProtocol` subclass designed to function as a local server for your application.
 When this class is registered as a URLProtocol, it will be consulted for all network requests before
 allowing them to go out to the network. As a result, the local server implementation is able to be 
 used without affecting any other networking code in the application.
 
 The barricade is defined by setting up `<MMBarricadeResponseSet>` objects, each composed of one or
 more `<MMBarricadeResponse>` objects. Each response set corresponds to a single API endpoint, and
 each response represents a possible response that the server might return for that endpoint. Consider
 the following example:
 
 - `<MMBarricadeResponseSet>` for the `/login` endpoint
 - `<MMBarricadeResponse>` representing a successfully authenticated response
 - `<MMBarricadeResponse>` representing an invalid credentials response
 - `<MMBarricadeResponse>` representing a user locked out response
 - `<MMBarricadeResponse>` representing a server unavailable response
 - `<MMBarricadeResponse>` representing no internet connection
 
 See `<MMBarricadeResponseSet>` for additional documentation on creating response sets.
 
 To setup the barricade, the following steps should be performed early in the lifecycle of your application,
 before any network requests are made.
 
 ```
 // Create an instance of a backing store which will be responsible for persisting the available
 // response sets and tell the barricade to use this backing store.
 id<MMBarricadeResponseStore> responseStore = [[MMBarricadeInMemoryResponseStore alloc] init];
 [MMBarricade setupWithResponseStore:responseStore];
 
 // Create a response set for each API endpoint and register them with the barricade.
 id<MMBarricadeResponseSet> loginSet = [self loginResponseSet];
 id<MMBarricadeResponseSet> movieListSet = [self movieListResponseSet];
 [MMBarricade registerResponseSet:loginSet];
 [MMBarricade registerResponseSet:movieListSet];
 ```
 */
@interface MMBarricade : NSURLProtocol

///--------------------------------
/// @name Setup
///--------------------------------

/**
 Configure the barricade to use the specified response store. The response store is responsible for
 persisting the configurations that are used by the application.
 */
+ (void)setupWithResponseStore:(id<MMBarricadeResponseStore>)responseStore;

/**
 Configure the barricade to use an In Memory response store. This store is reset each time the app
 is launched. This type of store is particularly useful for unit tests.
 */
+ (void)setupWithInMemoryResponseStore;

/**
 Enable the barricade for use with NSURLConnection-based requests, or NSURLSession-based requests
 that use the default session configuration.
 */
+ (void)enable;

/**
 Disable the barricade for use with NSURLConnection-based requests, or NSURLSession-based requests
 that use the default session configuration.
 */
+ (void)disable;

/**
 Enable the barricade for use with NSURLSession-based requests using the specified session configuration.

 @note This method should be called before creating a session with the session configuraiton.
 */
+ (void)enableForSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration;

/**
 Disable the barricade for use with NSURLSession-based requests using the specified session configuration.
 */
+ (void)disableForSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration;

///--------------------------------
/// @name Static Properties
///--------------------------------

/**
 Return the response store currently being used by the barricade.
 */
+ (id<MMBarricadeResponseStore>)responseStore;

/**
 This property controls whether requests that do not have registered responses will be blocked by the
 barricade or allowed through to the network. Set `YES` to block all requsets. If set to `YES`, and
 an incoming request does not have a registered resopnse, the request will fail with an error response.
 The default value is `YES`.
 */
+ (void)setAllRequestsBarricaded:(BOOL)allRequestsBarricaded;
+ (BOOL)allRequestsAreBarricaded;

/**
 This property specifies a global delay to apply to all barricade network responses. This can be useful
 for simulating slow network conditions. The default value is `0.0`.
 */
+ (void)setResponseDelay:(NSTimeInterval)responseDelay;
+ (NSTimeInterval)responseDelay;

///--------------------------------
/// @name Core Functionality
///--------------------------------

/**
 Register a response set to be consulted by incoming requests. Response sets are consulted in the order
 they are added.
 
 @param responseSet The responseSet to register.
 */
+ (void)registerResponseSet:(MMBarricadeResponseSet *)responseSet;

/**
 Remove a response set from the store. This response set will no longer be evaluated for future requests.

 @param responseSet The responseSet to unregister.
 */
+ (void)unregisterResponseSet:(MMBarricadeResponseSet *)responseSet;

/**
 Mark a particular reponse for a particular request as the "current" response. After a response has
 been marked as current, it will be returned by the barricade (rather than the default response) for
 all subsequent requests.
 
 @param responseName The `name` of the `<MMBarricadeResponse>` that should be marked as current.
 @param requestName The `requestName` of the `<MMBarricadeResponseSet>` that is responsible for
 responding to the request.
 */
+ (void)selectResponseForRequest:(NSString *)requestName withName:(NSString *)responseName;

///--------------------------------
/// @name Convenience Methods
///--------------------------------

/**
 This is a convenience method for stubbing a request without manually creating a response set first.
 A response set is internally created by this method and returned as the return value to the caller.
 */
+ (MMBarricadeResponseSet *)stubRequestsPassingTest:(BOOL (^)(NSURLRequest *request, NSURLComponents *components))testBlock
                                       withResponse:(id<MMBarricadeResponse> (^)(NSURLRequest *request))responseCreationBlock;

@end
