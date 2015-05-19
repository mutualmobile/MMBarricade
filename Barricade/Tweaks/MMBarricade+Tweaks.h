//
//  MMBarricade+Tweaks.h
//  Barricade
//
//  Created by John McIntosh on 5/14/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMBarricade.h"


/**
 The tweaks extension of MMBarricade integrates the barricade with Facebook Tweaks to create an 
 in-app menu the user can use to adjust network responses at runtime. 
 
 For example, when implementing a pull-to-refresh feature, this could be used to test all possible 
 network responses of the refresh to see how the UI responds without needing to ever relaunch the app.
 */
@interface MMBarricade (Tweaks)

/**
 Configure the barricade to use a Tweaks-based response store. This store is persisted between application
 launches and automatically builds a section in the Tweaks UI for viewing and choosing responses.
 */
+ (void)setupWithTweaksResponseStore;

@end
