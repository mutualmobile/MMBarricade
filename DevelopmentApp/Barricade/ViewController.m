//
//  ViewController.m
//  Barricade
//
//  Created by John McIntosh on 5/12/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "ViewController.h"
#import "MMBarricade.h"
#import "MMBarricadeViewController.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MMBarricade setupWithInMemoryResponseStore];
    
    // Create a response set for each API call that should be barricaded.
    MMBarricadeResponseSet *responseSet = [MMBarricadeResponseSet responseSetForRequestName:@"Login" respondsToRequest:^BOOL(NSURLRequest *request, NSURLComponents *components) {
        return [components.path hasSuffix:@"/login"];
    }];
    
    // Add Successful response
    [responseSet addResponseWithName:@"Success"
                                file:MMPathForFileInMainBundleDirectory(@"login.success.json", @"LocalServer")
                          statusCode:200
                         contentType:@"application/json"];
    
    // Add Invalid Credentials response
    [responseSet addResponseWithName:@"Invalid Credentials"
                                file:MMPathForFileInMainBundleDirectory(@"login.invalid.json", @"LocalServer")
                          statusCode:401
                         contentType:@"application/json"];
    
    // Add No Network Connection response
    [responseSet addResponseWithName:@"Offline"
                               error:[NSError errorWithDomain:NSURLErrorDomain
                                                         code:NSURLErrorNotConnectedToInternet
                                                     userInfo:nil]];
    
    // Register the response set
    [MMBarricade registerResponseSet:responseSet];
}

- (IBAction)presentButtonPressed:(id)sender {
    MMBarricadeViewController *viewController = [[MMBarricadeViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
