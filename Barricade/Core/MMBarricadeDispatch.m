//
//  MMBarricadeDispatch.m
//  Barricade
//
//  Created by John McIntosh on 5/13/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMBarricadeDispatch.h"


@interface MMBarricadeDispatch ()

@property (nonatomic, strong) id<MMBarricadeResponseStore> responseStore;

@end


@implementation MMBarricadeDispatch

- (instancetype)initWithResponseStore:(id<MMBarricadeResponseStore>)responseStore {
    self = [super init];
    if (self != nil) {
        if (responseStore == nil) return nil;
        _responseStore = responseStore;
    }
    return self;
}

- (void)registerResponseSet:(MMBarricadeResponseSet *)responseSet {
    [self.responseStore registerResponseSet:responseSet];
}

- (id<MMBarricadeResponse>)responseForRequest:(NSURLRequest *)request {
    MMBarricadeResponseSet *responseSet = [self responseSetForRequest:request];
    id<MMBarricadeResponse> response = [self.responseStore currentResponseForResponseSet:responseSet];
    return response;
}

- (void)resetResponseSelections {
    [self.responseStore resetResponseSelections];
}

- (void)selectResponseforRequest:(NSString *)requestName withResponseName:(NSString *)responseName {
    MMBarricadeResponseSet *responseSet = [self responseSetForRequestWithName:requestName];
    [self.responseStore selectCurrentResponseForResponseSet:responseSet withName:responseName];
}


#pragma mark - Private

- (MMBarricadeResponseSet *)responseSetForRequest:(NSURLRequest *)request {
    for (MMBarricadeResponseSet *responseSet in self.responseStore.allResponseSets) {
        NSURLComponents *components = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:NO];
        if (responseSet.respondsToRequest(request, components)) {
            return responseSet;
        }
    }
    return nil;
}

- (MMBarricadeResponseSet *)responseSetForRequestWithName:(NSString *)requestName {
    for (MMBarricadeResponseSet *responseSet in self.responseStore.allResponseSets) {
        if ([responseSet.requestName isEqualToString:requestName]) {
            return responseSet;
        }
    }
    return nil;
}

@end
