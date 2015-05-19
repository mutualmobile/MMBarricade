//
//  MMBarricadeDispatch.h
//  Barricade
//
//  Created by John McIntosh on 5/13/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMBarricadeResponseStore.h"
#import "MMBarricadeResponseSet.h"


/**
 This private class manages the logic of looking up the appropriate response to return for any given
 incoming request.
 */
@interface MMBarricadeDispatch : NSObject

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

@end
