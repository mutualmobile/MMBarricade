//
//  MMBarricadeResponseSet.m
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
