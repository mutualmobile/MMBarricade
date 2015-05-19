//
//  MMBarricadeResponseSet.m
//  Barricade
//
//  Created by John McIntosh on 5/12/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMBarricadeResponseSet.h"


@interface MMBarricadeResponseSet ()

@property (nonatomic, strong) NSMutableArray *mutableResponseList;

@end


@implementation MMBarricadeResponseSet
@synthesize defaultResponse = _defaultResponse;

- (instancetype)init {
    return [self initWithRequestName:nil respondsToRequest:nil];
}

- (instancetype)initWithRequestName:(NSString *)requestName
                  respondsToRequest:(BOOL (^)(NSURLRequest *request, NSURLComponents *components))respondsToRequest {
    self = [super init];
    if (self != nil) {
        _mutableResponseList = [NSMutableArray array];
        _requestName = [requestName copy];
        _respondsToRequest = [respondsToRequest copy];
    }
    return self;
}

+ (instancetype)responseSetForRequestName:(NSString *)requestName
                        respondsToRequest:(BOOL (^)(NSURLRequest *request, NSURLComponents *components))respondsToRequest {
    return [[[self class] alloc] initWithRequestName:requestName respondsToRequest:respondsToRequest];
}


#pragma mark - Public

- (void)addResponse:(id<MMBarricadeResponse>)response {
    if (response) {
        [self.mutableResponseList addObject:response];
    }
}

- (void)createResponseWithBlock:(id<MMBarricadeResponse> (^)(void))creationBlock {
    if (creationBlock) {
        id<MMBarricadeResponse> response = creationBlock();
        [self addResponse:response];
    }
}

- (void)createResponseWithName:(NSString *)name
               populationBlock:(void (^)(MMBarricadeResponse *))populationBlock {
    
    MMBarricadeResponse *response = [[MMBarricadeResponse alloc] init];
    response.name = name;
    if (populationBlock) {
        populationBlock(response);
    }
    [self addResponse:response];
}

- (id<MMBarricadeResponse>)defaultResponse {
    if (_defaultResponse == nil) {
        return [self.allResponses firstObject];
    }
    return _defaultResponse;
}

- (void)setDefaultResponse:(id<MMBarricadeResponse>)defaultResponse {
    if ([self.allResponses containsObject:defaultResponse]) {
        _defaultResponse = defaultResponse;
    }
}

- (NSArray *)allResponses {
    return [self.mutableResponseList copy];
}

- (void)setAllResponses:(NSArray *)allResponses {
    if ([allResponses containsObject:self.defaultResponse] == NO) {
        _defaultResponse = nil;
    }
    self.mutableResponseList = [allResponses mutableCopy];
}

- (id<MMBarricadeResponse>)responseWithName:(NSString *)responseName {
    for (id<MMBarricadeResponse> response in self.allResponses) {
        if ([response.name isEqualToString:responseName]) {
            return response;
        }
    }
    return nil;
}

@end
