//
//  MMBarricadeTweaksResponseStore.h
//  Barricade
//
//  Created by John McIntosh on 3/13/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMBarricadeAbstractResponseStore.h"


/**
 A Tweaks response store maintains information about selected responses in Facebook Tweaks. When
 utilizing a Tweaks response store, the registered configurations will be exposed through the Tweaks
 UI and can be adjusted at runtime. This can be useful when testing how you application UI responds
 to different possible API responses.
 */
@interface MMBarricadeTweaksResponseStore : MMBarricadeAbstractResponseStore

/**
 Return the category name used by Facebook Tweaks. Defaults to "MMBarricade".
 */
+ (NSString *)tweaksCategoryName;

/**
 Set the category name used by Facebook Tweaks. Defaults to "MMBarricade".
 */
+ (void)setTweaksCategoryName:(NSString *)categoryName;

/**
 Return the collection name used by Facebook Tweaks. Defaults to "Local Server".
 */
+ (NSString *)tweaksCollectionName;

/**
 Set the category name used by Facebook Tweaks. Defaults to "Local Server".
 */
+ (void)setTweaksCollectionName:(NSString *)collectionName;

@end
