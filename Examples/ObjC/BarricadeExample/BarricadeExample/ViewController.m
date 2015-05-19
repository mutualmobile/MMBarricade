//
//  ViewController.m
//  BarricadeExample
//
//  Created by John McIntosh on 5/8/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "ViewController.h"
#import "MMBarricade.h"


@interface ViewController ()

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
    [MMBarricade setupWithInMemoryResponseStore];
    [MMBarricade enable];
    
    [MMBarricade stubRequestsPassingTest:^BOOL(NSURLRequest *request, NSURLComponents *components) {
        return [components.path hasSuffix:@"search/repositories"];
    } withResponse:^id<MMBarricadeResponse>(NSURLRequest *request) {
        NSString *filepath = MMPathForFileInMainBundleDirectory(@"search.success.json", @"LocalServerFiles");
        return [MMBarricadeResponse responseWithName:@"success"
                                                file:filepath
                                          statusCode:200
                                         contentType:@"application/json"];
    }];
}


#pragma mark - IBActions

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

@end
