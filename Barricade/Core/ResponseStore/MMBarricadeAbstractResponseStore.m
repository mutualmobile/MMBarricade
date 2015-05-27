//
//  MMBarricadeAbstractResponseStore.m
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

#import "MMBarricadeAbstractResponseStore.h"


@interface MMBarricadeAbstractResponseStore ()

@property (nonatomic, strong) NSMutableArray *registeredResponseSets;

@end


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

- (MMBarricadeResponseSet *)responseSetForRequestWithName:(NSString *)requestName {
    for (MMBarricadeResponseSet *responseSet in self.allResponseSets) {
        if ([responseSet.requestName isEqualToString:requestName]) {
            return responseSet;
        }
    }
    return nil;
}

- (void)unregisterResponseSet:(MMBarricadeResponseSet *)responseSet {
    [self.registeredResponseSets removeObject:responseSet];
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
