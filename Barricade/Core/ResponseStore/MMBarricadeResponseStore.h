//
//  MMBarricadeResponseStore.h
//  Barricade
//
//  Created by John McIntosh on 5/12/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMBarricadeResponseSet.h"
#import "MMBarricadeResponse.h"


/**
 A concrete implementation of `<MMBarricadeResponseStore>` is responsible for maintaining registered
 response sets and their currently selected responses.
 */
@protocol MMBarricadeResponseStore <NSObject>

/**
 Return all registered resposne sets.
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
 Change the response that will be returned from the specified response set the next time that
 `-currentResponseForResponseSet:` is called.
 
 Programmatically calling this method can be beneficial during integration tests. For example, this
 could be called at the beginning of each test case to configure the barricade to return a different
 server response for each test case.
 */
- (void)selectCurrentResponseForResponseSet:(MMBarricadeResponseSet *)responseSet
                                   withName:(NSString *)name;

@end
