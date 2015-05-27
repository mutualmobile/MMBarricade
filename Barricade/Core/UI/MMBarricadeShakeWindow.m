//
//  MMBarricadeShakeWindow.m
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

#import "MMBarricadeShakeWindow.h"
#import "MMBarricadeViewController.h"


@implementation MMBarricadeShakeWindow

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if ([self shouldPresentBarricade]) {
                [self presentBarricade];
            }
        });
    }
    [super motionBegan:motion withEvent:event];
}

- (void)presentBarricade {
    UIViewController *topViewController = self.rootViewController;
    while (topViewController.presentedViewController != nil) {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([self viewControllerIsBarricadeViewController:topViewController] == NO) {
        MMBarricadeViewController *viewController = [[MMBarricadeViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [topViewController presentViewController:navigationController animated:YES completion:NULL];
    }
}

- (BOOL)shouldPresentBarricade {
    return YES;
}

- (BOOL)viewControllerIsBarricadeViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)viewController;
        if ([navController.viewControllers.firstObject isKindOfClass:[MMBarricadeViewController class]]) {
            return YES;
        }
    }
    return NO;
}

@end
