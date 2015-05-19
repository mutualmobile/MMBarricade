//
//  MMBarricade+Tweaks.m
//  Barricade
//
//  Created by John McIntosh on 5/14/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMBarricade+Tweaks.h"
#import "MMBarricadeTweaksResponseStore.h"


@implementation MMBarricade (Tweaks)

+ (void)setupWithTweaksResponseStore {
    id<MMBarricadeResponseStore> responseStore = [[MMBarricadeTweaksResponseStore alloc] init];
    [MMBarricade setupWithResponseStore:responseStore];
}

@end
