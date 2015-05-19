//
//  MMBarricadeAbstractResponseStore.h
//  Barricade
//
//  Created by John McIntosh on 5/12/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMBarricadeResponseStore.h"


/**
 The abstract response store implements a basic set of functionality that would likely be used by
 any concrete implementation of <MMBarricadeResponseStore>. This class should not be used directly,
 only through its subclasses. The following methods are required to be overridden in any subclass
 implementation:
 
 ```
 - (id<MMBarricadeResponse>)currentResponseForResponseSet:(MMBarricadeResponseSet *)responseSet;
 - (void)resetResponseSelections;
 - (void)selectCurrentResponseForResponseSet:(MMBarricadeResponseSet *)responseSet
                                    withName:(NSString *)name;
```
 */
@interface MMBarricadeAbstractResponseStore : NSObject <MMBarricadeResponseStore>

/**
 Array containing all response sets that have been registered with the store, in the order that they
 were registered.
 */
@property (nonatomic, strong) NSMutableArray *registeredResponseSets;

@end
