//
//  MMBarricadeInMemoryResponseStore.h
//  Barricade
//
//  Created by John McIntosh on 5/12/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMBarricadeAbstractResponseStore.h"


/**
 An In-Memory response store is a lightweight, transient store that maintains its configurations for
 the duration of the app's execution. When the app is terminated the store is released.
 */
@interface MMBarricadeInMemoryResponseStore : MMBarricadeAbstractResponseStore

@end
