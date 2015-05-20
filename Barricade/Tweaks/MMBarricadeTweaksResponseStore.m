//
//  MMBarricadeTweaksResponseStore.m
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

#import "MMBarricadeTweaksResponseStore.h"
#import "MMBarricadeResponse.h"
#import "MMBarricadeResponseSet.h"

#import "FBTweak.h"
#import "FBTweakStore.h"
#import "FBTweakCategory.h"
#import "FBTweakCollection.h"


@implementation MMBarricadeTweaksResponseStore

- (instancetype)init {
    self = [super init];
    if (self) {
        _tweaksCategoryName = @"MMBarricade";
        _tweaksCollectionName = @"Local Server";
    }
    return self;
}


#pragma mark - MMBarricadeResponseStore

- (void)registerResponseSet:(MMBarricadeResponseSet *)responseSet {
    [super registerResponseSet:responseSet];
    [self tweakForResponseSet:responseSet];
}


#pragma mark Selection Management

- (id<MMBarricadeResponse>)currentResponseForResponseSet:(MMBarricadeResponseSet *)responseSet {
    FBTweak *tweak = [self tweakForResponseSet:responseSet];
    FBTweakValue value = tweak.currentValue ?: tweak.defaultValue;
    id<MMBarricadeResponse> response = [responseSet responseWithName:value];
    return response;
}

- (void)resetResponseSelections {
    FBTweakStore *store = [FBTweakStore sharedInstance];
    [store reset];
}

- (void)selectCurrentResponseForResponseSet:(MMBarricadeResponseSet *)responseSet
                                   withName:(NSString *)name {
    
    FBTweak *tweak = [self tweakForResponseSet:responseSet];
    tweak.currentValue = name;
}


#pragma mark - Private

- (FBTweak *)tweakForResponseSet:(MMBarricadeResponseSet *)responseSet {
    NSMutableArray *responseNames = [NSMutableArray array];
    for (id<MMBarricadeResponse> response in responseSet.allResponses) {
        [responseNames addObject:response.name];
    }
    
    FBTweak *tweak = mm_FBArrayTweak(self.tweaksCategoryName,
                                     self.tweaksCollectionName,
                                     responseSet.requestName,
                                     responseSet.defaultResponse.name,
                                     responseNames);
    return tweak;
}


#pragma mark - Array Tweak Helpers

FBTweak *mm_FBArrayTweak(NSString *categoryName, NSString *collectionName, NSString *tweakName, id defaultValue, NSArray *array) {
    FBTweakStore *store = [FBTweakStore sharedInstance];
    FBTweakCategory *category = [store tweakCategoryWithName:categoryName];
    if (!category) {
        category = [[FBTweakCategory alloc] initWithName:categoryName];
        [store addTweakCategory:category];
    }
    
    FBTweakCollection *collection = [category tweakCollectionWithName:collectionName];
    if (!collection) {
        collection = [[FBTweakCollection alloc] initWithName:collectionName];
        [category addTweakCollection:collection];
    }
    
    FBTweak *tweak = [collection tweakWithIdentifier:tweakName];
    if (!tweak) {
        tweak = [[FBTweak alloc] initWithIdentifier:tweakName];
        tweak.name = tweakName;
        tweak.possibleValues = array;
        tweak.defaultValue = defaultValue;
        [collection addTweak:tweak];
    }
    return tweak;
}

@end
