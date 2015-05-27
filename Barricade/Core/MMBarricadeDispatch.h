//
//  MMBarricadeDispatch.h
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
#import "MMBarricadeResponseStore.h"
#import "MMBarricadeResponseSet.h"


/**
 This private class manages the logic of looking up the appropriate response to return for any given
 incoming request.
 */
@interface MMBarricadeDispatch : NSObject

/**
 Return the response store currnetly being used by the dispatch.
 */
@property (nonatomic, strong, readonly) id<MMBarricadeResponseStore> responseStore;

/**
 Designated initializer. This initializer must be called with an instance of a response store. The
 response store is responsible for specifying where/how the available response sets are persisted.
 
 @param responseStore The response store which will persist available responses.
 */
- (instancetype)initWithResponseStore:(id<MMBarricadeResponseStore>)responseStore NS_DESIGNATED_INITIALIZER;
- (instancetype)init __attribute__((unavailable("Use the designated initializer -initWithResponseStore:")));

/**
 Register a response set to be consulted by incoming requests. Response sets are consulted in the order
 they are added.
 
 @param responseSet The responseSet to register.
 */
- (void)registerResponseSet:(MMBarricadeResponseSet *)responseSet;

/**
 Return the current response for the provided incoming request.
 
 @param request The incoming network request.
 */
- (id<MMBarricadeResponse>)responseForRequest:(NSURLRequest *)request;

/**
 Reset all the currently selected response on all response sets to the set's default response.
 */
- (void)resetResponseSelections;

/**
 Mark a particular reponse for a particular request as the "current" response. After a response has
 been marked as current, it will be returned by the barricade (rather than the default response) for
 all subsequent requests.
 
 @param responseName The `name` of the `<MMBarricadeResponse>` that should be marked as current.
 @param requestName The `requestName` of the `<MMBarricadeResponseSet>` that is responsible for
 responding to the request.
 */
- (void)selectResponseforRequest:(NSString *)requestName withResponseName:(NSString *)responseName;

/**
 Remove a response set from the store. This response set will no longer be evaluated for future requests.
 */
- (void)unregisterResponseSet:(MMBarricadeResponseSet *)responseSet;

@end
