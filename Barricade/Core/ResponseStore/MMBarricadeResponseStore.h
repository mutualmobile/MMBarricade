//
//  MMBarricadeResponseStore.h
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
#import "MMBarricadeResponseSet.h"
#import "MMBarricadeResponse.h"


/**
 A concrete implementation of `<MMBarricadeResponseStore>` is responsible for maintaining registered
 response sets and their currently selected responses.
 */
@protocol MMBarricadeResponseStore <NSObject>

/**
 Return all registered response sets.
 */
- (NSArray *)allResponseSets;

/**
 Return the currently selected response for the specified response set.
 
 For example, assume this response set contains all possible responses at the `/login` API endpoint.
 Initailly, the return value would be the response set's `defaultResponse`. However,
 `-selectCurrentResponseForResponseSet:withName:` can be called to change the return value of this
 method from the default response to another response.
 */
- (id<MMBarricadeResponse>)currentResponseForResponseSet:(MMBarricadeResponseSet *)responseSet;

/**
 Register a response set.
 */
- (void)registerResponseSet:(MMBarricadeResponseSet *)responseSet;

/**
 Reset all the currently selected response on all response sets to the set's default response.
 */
- (void)resetResponseSelections;

/**
 Return the response set that will be used to response to the specified request.
 */
- (MMBarricadeResponseSet *)responseSetForRequest:(NSURLRequest *)request;

/**
 Return the response set that has the specified name.
 */
- (MMBarricadeResponseSet *)responseSetForRequestWithName:(NSString *)requestName;

/**
 Change the response that will be returned from the specified response set the next time that
 `-currentResponseForResponseSet:` is called.
 
 Programmatically calling this method can be beneficial during integration tests. For example, this
 could be called at the beginning of each test case to configure the barricade to return a different
 server response for each test case.
 */
- (void)selectCurrentResponseForResponseSet:(MMBarricadeResponseSet *)responseSet
                                   withName:(NSString *)name;

/**
 Remove a response set from the store. This response set will no longer be evaluated for future requests.
 */
- (void)unregisterResponseSet:(MMBarricadeResponseSet *)responseSet;

@end
