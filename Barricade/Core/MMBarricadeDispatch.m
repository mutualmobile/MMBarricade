//
//  MMBarricadeDispatch.m
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

- (id<MMBarricadeResponseStore>)responseStore {
    return _responseStore;
}

- (void)registerResponseSet:(MMBarricadeResponseSet *)responseSet {
    [self.responseStore registerResponseSet:responseSet];
}

- (id<MMBarricadeResponse>)responseForRequest:(NSURLRequest *)request {
    MMBarricadeResponseSet *responseSet = [self.responseStore responseSetForRequest:request];
    id<MMBarricadeResponse> response = [self.responseStore currentResponseForResponseSet:responseSet];
    return response;
}

- (void)resetResponseSelections {
    [self.responseStore resetResponseSelections];
}

- (void)selectResponseforRequest:(NSString *)requestName withResponseName:(NSString *)responseName {
    MMBarricadeResponseSet *responseSet = [self.responseStore responseSetForRequestWithName:requestName];
    [self.responseStore selectCurrentResponseForResponseSet:responseSet withName:responseName];
}

- (void)unregisterResponseSet:(MMBarricadeResponseSet *)responseSet {
    [self.responseStore unregisterResponseSet:responseSet];
}

@end
