//
//  MMBarricadeAbstractResponseStore.m
//  Barricade
//
//  Created by John McIntosh on 5/12/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMBarricadeAbstractResponseStore.h"


@implementation MMBarricadeAbstractResponseStore

- (instancetype)init {
    self = [super init];
    if (self) {
        _registeredResponseSets = [NSMutableArray array];
    }
    return self;
}


#pragma mark - MMBarricadeResponseStore

- (NSArray *)allResponseSets {
    return [self.registeredResponseSets copy];
}

- (void)registerResponseSet:(MMBarricadeResponseSet *)responseSet {
    [self.registeredResponseSets addObject:responseSet];
}

- (MMBarricadeResponseSet *)responseSetForRequest:(NSURLRequest *)request {
    for (MMBarricadeResponseSet *responseSet in self.allResponseSets) {
        NSURLComponents *components = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:NO];
        if (responseSet.respondsToRequest(request, components)) {
            return responseSet;
        }
    }
    return nil;
}


#pragma mark Selection Management

- (id<MMBarricadeResponse>)currentResponseForResponseSet:(MMBarricadeResponseSet *)responseSet {
    NSLog(@"MMBarricadeAbstractResponseStore does not support %@ and requires a subclass implementation "
          "to provide this functionality.", NSStringFromSelector(_cmd));
    return nil;
}

- (void)resetResponseSelections {
    NSLog(@"MMBarricadeAbstractResponseStore does not support %@ and requires a subclass implementation "
          "to provide this functionality.", NSStringFromSelector(_cmd));
}

- (void)selectCurrentResponseForResponseSet:(MMBarricadeResponseSet *)responseSet
                                   withName:(NSString *)name {
    
    NSLog(@"MMBarricadeAbstractResponseStore does not support %@ and requires a subclass implementation "
          "to provide this functionality.", NSStringFromSelector(_cmd));
}

@end
