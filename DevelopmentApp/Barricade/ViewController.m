//
//  ViewController.m
//  Barricade
//
//  Created by John McIntosh on 5/12/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "ViewController.h"
#import "MMBarricade.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self basicStubbing];
}

- (void)basicStubbing {
    [MMBarricade stubRequestsPassingTest:^BOOL(NSURLRequest *request, NSURLComponents *components) {
        return [components.path hasSuffix:@"search"];
    } withResponse:^id<MMBarricadeResponse>(NSURLRequest *request) {
        NSString *filename = @"search.success.json";
        NSString *directory = @"LocalServerResources";
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *filepath = [bundle pathForResource:filename ofType:nil inDirectory:directory];
        
        MMBarricadeResponse *data = [[MMBarricadeResponse alloc] init];
        data.contentData = [NSData dataWithContentsOfFile:filepath];
        data.statusCode = 200;
        data.contentType = @"application/json";
        return data;
    }];
}

- (void)basicResponseSetCreation {
    MMBarricadeResponseSet *responseSet = [[MMBarricadeResponseSet alloc] initWithRequestName:@"Search" respondsToRequest:^BOOL(NSURLRequest *request, NSURLComponents *components) {
        return [components.path hasSuffix:@"search"];
    }];
    
    MMBarricadeResponse *response = [[MMBarricadeResponse alloc] init];
    response.name = @"success";
    [response setDynamicResponseForRequest:^id<MMBarricadeResponse>(NSURLRequest *request) {
        MMBarricadeResponse *data = [[MMBarricadeResponse alloc] init];
        data.contentType = @"application/json";
        data.statusCode = 200;
        return data;
    }];
    
    [responseSet addResponse:response];
}

- (void)convenienceResponseSetCreation {
    MMBarricadeResponseSet *responseSet = [MMBarricadeResponseSet responseSetForRequestName:@"Search" respondsToRequest:^BOOL(NSURLRequest *request, NSURLComponents *components) {
        return [components.path hasSuffix:@"search"];
    }];
    [responseSet createResponseWithBlock:^id<MMBarricadeResponse>{
        MMBarricadeResponse *response = [[MMBarricadeResponse alloc] init];
        response.name = @"success";
        response.statusCode = 200;
        return response;
    }];
    [responseSet createResponseWithName:@"failure" populationBlock:^(MMBarricadeResponse *response) {
        response.statusCode = 404;
    }];
}

@end
