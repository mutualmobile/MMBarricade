//
//  ViewController.m
//  BarricadeTweaksExample
//
//  Created by John McIntosh on 5/8/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "ViewController.h"
#import "FBTweakViewController.h"
#import "FBTweakStore.h"
#import "MMBarricade.h"
#import "MMBarricade+Tweaks.h"


@interface ViewController () <FBTweakViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusCodeLabel;
@property (nonatomic, weak) IBOutlet UITextView *resposneHeadersTextView;
@property (nonatomic, weak) IBOutlet UITextView *resposneTextView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBarricade];
}

- (void)configureBarricade {
    [MMBarricade setupWithTweaksResponseStore];
    [MMBarricade enable];

    MMBarricadeResponseSet *responseSet = [MMBarricadeResponseSet responseSetForRequestName:@"Search" respondsToRequest:^BOOL(NSURLRequest *request, NSURLComponents *components) {
        return [components.path hasSuffix:@"search/repositories"];
    }];
    
    [responseSet createResponseWithBlock:^id<MMBarricadeResponse>{
        NSString *filepath = MMPathForFileInMainBundleDirectory(@"search.success.json", @"LocalServerFiles");
        return [MMBarricadeResponse responseWithName:@"success"
                                                file:filepath
                                          statusCode:200
                                         contentType:@"application/json"];
    }];

    [responseSet createResponseWithBlock:^id<MMBarricadeResponse>{
        NSString *filepath = MMPathForFileInMainBundleDirectory(@"search.empty.json", @"LocalServerFiles");
        return [MMBarricadeResponse responseWithName:@"no results"
                                                file:filepath
                                          statusCode:200
                                         contentType:@"application/json"];
    }];

    [responseSet createResponseWithBlock:^id<MMBarricadeResponse>{
        NSString *filepath = MMPathForFileInMainBundleDirectory(@"search.ratelimited.json", @"LocalServerFiles");
        NSDictionary *headers = @{
                                  @"X-RateLimit-Limit": @"60",
                                  @"X-RateLimit-Remaining": @"0",
                                  @"X-RateLimit-Reset": @"1377013266",
                                  MMBarricadeContentTypeHeaderKey: @"application/json",
                                  };
        return [MMBarricadeResponse responseWithName:@"rate limited"
                                                file:filepath
                                          statusCode:403
                                             headers:headers];
    }];
    
    [MMBarricade registerResponseSet:responseSet];
}


#pragma mark - IBActions

- (IBAction)tweaksButtonPressed:(id)sender {
    FBTweakViewController *viewController = [[FBTweakViewController alloc] initWithStore:[FBTweakStore sharedInstance]];
    viewController.tweaksDelegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)triggerRequestButtonPressed:(id)sender {
    // Fetch the top 5 most starred Objective-C repositories on Github
    NSURL *URL = [NSURL URLWithString:@"https://api.github.com/search/repositories?q=language:Objective-C&sort=stars&order=desc&per_page=5"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *URLResponse, NSData *data, NSError *connectionError) {
         NSHTTPURLResponse *response = (NSHTTPURLResponse *)URLResponse;
         self.statusCodeLabel.text = [NSString stringWithFormat:@"%li", (long)response.statusCode];
         self.resposneHeadersTextView.text = response.allHeaderFields.description;
         self.resposneTextView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     }];
}


#pragma mark - Tweaks

- (void)tweakViewControllerPressedDone:(FBTweakViewController *)tweakViewController {
    [tweakViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
