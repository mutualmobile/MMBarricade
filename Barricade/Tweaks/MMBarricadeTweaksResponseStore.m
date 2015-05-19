//
//  MMBarricadeTweaksResponseStore.m
//  Barricade
//
//  Created by John McIntosh on 3/13/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMBarricadeTweaksResponseStore.h"
#import "MMBarricadeResponse.h"
#import "MMBarricadeResponseSet.h"

#import "FBTweak.h"
#import "FBTweakStore.h"
#import "FBTweakCategory.h"
#import "FBTweakCollection.h"


static NSString * kTweaksCategoryName = @"MMBarricade";
static NSString * kTweaksCollectionName = @"Local Server";


@implementation MMBarricadeTweaksResponseStore


#pragma mark - Public

+ (void)setTweaksCategoryName:(NSString *)categoryName {
    kTweaksCategoryName = categoryName;
}

+ (NSString *)tweaksCategoryName {
    return kTweaksCategoryName;
}

+ (void)setTweaksCollectionName:(NSString *)collectionName {
    kTweaksCollectionName = collectionName;
}

+ (NSString *)tweaksCollectionName {
    return kTweaksCollectionName;
}


#pragma mark - MMBarricadeResponseStore

- (void)registerResponseSet:(MMBarricadeResponseSet *)responseSet {
    [super registerResponseSet:responseSet];
    [self tweakForResponseSet:responseSet];
}

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
    
    FBTweak *tweak = mm_FBArrayTweak([[self class] tweaksCategoryName],
                                     [[self class] tweaksCollectionName],
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
