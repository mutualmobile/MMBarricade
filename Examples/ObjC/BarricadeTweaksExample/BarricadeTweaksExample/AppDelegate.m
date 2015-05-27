//
//  AppDelegate.m
//  BarricadeTweaksExample
//
//  Created by John McIntosh on 5/8/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "AppDelegate.h"
#import "FBTweakShakeWindow.h"


@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (UIWindow *)window {
    if (!_window) {
        _window = [[FBTweakShakeWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    return _window;
}

@end
