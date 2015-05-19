//
//  MMBarricadeInMemoryResponseStore.m
//  Barricade
//
//  Created by John McIntosh on 5/12/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMBarricadeInMemoryResponseStore.h"


@interface MMBarricadeInMemoryResponseStore ()

@property (nonatomic, strong) NSMutableDictionary *currentResponseForSet;

@end


@implementation MMBarricadeInMemoryResponseStore

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentResponseForSet = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id<MMBarricadeResponse>)currentResponseForResponseSet:(MMBarricadeResponseSet *)responseSet {
    id<MMBarricadeResponse> response = self.currentResponseForSet[responseSet.requestName];
    if (response == nil) {
        response = responseSet.defaultResponse;
    }
    return response;
}

- (void)resetResponseSelections {
    [self.currentResponseForSet removeAllObjects];
}

- (void)selectCurrentResponseForResponseSet:(MMBarricadeResponseSet *)responseSet
                                   withName:(NSString *)name {
    
    id<MMBarricadeResponse> response = [responseSet responseWithName:name];
    if (response) {
        self.currentResponseForSet[responseSet.requestName] = response;
    }
}

@end
