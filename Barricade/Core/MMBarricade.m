//
//  MMBarricade.m
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

#import "MMBarricade.h"
#import "MMBarricadeDispatch.h"
#import "MMBarricadeInMemoryResponseStore.h"


static MMBarricadeDispatch * dispatch;
static BOOL _allRequestsAreBarricaded;
static NSTimeInterval _responseDelay;


@interface MMBarricade ()

@property (nonatomic, assign) BOOL canceled;

@end


@implementation MMBarricade

#pragma mark - Public Interface
#pragma mark Configuration

+ (void)setupWithResponseStore:(id<MMBarricadeResponseStore>)responseStore {
    dispatch = [[MMBarricadeDispatch alloc] initWithResponseStore:responseStore];
    [self setAllRequestsBarricaded:YES];
    [self setResponseDelay:0.0];
}

+ (void)setupWithInMemoryResponseStore {
    id<MMBarricadeResponseStore> store = [[MMBarricadeInMemoryResponseStore alloc] init];
    [self setupWithResponseStore:store];
}

+ (void)enable {
    [NSURLProtocol registerClass:[self class]];
}

+ (void)enableForSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration {
    NSMutableArray *protocolClasses = [sessionConfiguration.protocolClasses mutableCopy] ?: [NSMutableArray array];
    if ([protocolClasses containsObject:[self class]] == NO) {
        [protocolClasses insertObject:[self class] atIndex:0];
    }
    sessionConfiguration.protocolClasses = protocolClasses;
}

+ (void)disable {
    [NSURLProtocol unregisterClass:[self class]];
}

+ (void)disableForSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration {
    NSMutableArray *protocolClasses = [sessionConfiguration.protocolClasses mutableCopy];
    if ([protocolClasses containsObject:[self class]]) {
        [protocolClasses removeObject:[self class]];
    }
    sessionConfiguration.protocolClasses = protocolClasses;
}


#pragma mark - Properties

+ (id<MMBarricadeResponseStore>)responseStore {
    return [dispatch responseStore];
}

+ (void)setAllRequestsBarricaded:(BOOL)allRequestsBarricaded {
    _allRequestsAreBarricaded = allRequestsBarricaded;
}

+ (BOOL)allRequestsAreBarricaded {
    return _allRequestsAreBarricaded;
}

+ (void)setResponseDelay:(NSTimeInterval)responseDelay {
    _responseDelay = responseDelay;
}

+ (NSTimeInterval)responseDelay {
    return _responseDelay;
}


#pragma mark Response Management

+ (void)registerResponseSet:(MMBarricadeResponseSet *)responseSet {
    [dispatch registerResponseSet:responseSet];
}

+ (void)selectResponseForRequest:(NSString *)requestName withName:(NSString *)responseName {
    [dispatch selectResponseforRequest:requestName withResponseName:responseName];
}

+ (MMBarricadeResponseSet *)stubRequestsPassingTest:(BOOL (^)(NSURLRequest *request, NSURLComponents *components))testBlock
                                       withResponse:(id<MMBarricadeResponse> (^)(NSURLRequest *request))responseCreationBlock {

    MMBarricadeResponse *response = [[MMBarricadeResponse alloc] init];
    response.name = @"Standard Response";
    response.dynamicResponseForRequest = [responseCreationBlock copy];

    MMBarricadeResponseSet *responseSet = [[MMBarricadeResponseSet alloc] initWithRequestName:@"Unnamed Request"
                                                                            respondsToRequest:testBlock];
    [responseSet addResponse:response];
    
    [self registerResponseSet:responseSet];
    
    return responseSet;
}

+ (void)unregisterResponseSet:(MMBarricadeResponseSet *)responseSet {
    [dispatch unregisterResponseSet:responseSet];
}


#pragma mark - NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([self allRequestsAreBarricaded]) {
        return YES;
    }
    id<MMBarricadeResponse> response = [dispatch responseForRequest:request];
    return (response != nil);
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    id<MMBarricadeResponse> response = [dispatch responseForRequest:self.request];
    if (response) {
        id<MMBarricadeResponse> updatedResponse = response.responseForRequest(self.request);
        if (updatedResponse.error) {
            [self.client URLProtocol:self didFailWithError:updatedResponse.error];
        }
        else {
            [self triggerResponseToRequest:self.request
                                  withData:updatedResponse.contentData
                                   headers:updatedResponse.allHeaderFields
                                statusCode:updatedResponse.statusCode];
        }
    }
    else {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[NSLocalizedDescriptionKey] = [NSString stringWithFormat:@"MMBarricade attempted to return a response, but no response has been registered that is capable of responding to the request to the URL: %@", self.request.URL.absoluteString];
        userInfo[NSLocalizedRecoverySuggestionErrorKey] = @"This scenario happens in one of two cases. 1) The barricade has been setup with `allRequestsAreBarricaded` set to `YES` and an outgoing request has not been mapped to a response. 2) If only registered requests are barricaded, then this error would indicate that a request has been canceled by the client application before the response was able to be triggered.";
        NSError *error = [NSError errorWithDomain:@"com.mutualmobile.barricade" code:MMBarricadeErrorNoRegisteredResponse userInfo:userInfo];
        [self.client URLProtocol:self didFailWithError:error];
    }
}

- (void)stopLoading {
    self.canceled = YES;
}


#pragma mark - Private

- (void)triggerResponseToRequest:(NSURLRequest *)request
                        withData:(NSData *)data
                         headers:(NSDictionary *)headers
                      statusCode:(NSInteger)statusCode
{
    id <NSURLProtocolClient> client = self.client;
    
    NSTimeInterval delay = [[self class] responseDelay];
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(dispatchTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.canceled == NO) {
            NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] initWithURL:request.URL
                                                                         statusCode:statusCode
                                                                        HTTPVersion:@""
                                                                       headerFields:headers];
            
            [client URLProtocol:self didReceiveResponse:urlResponse cacheStoragePolicy:NSURLCacheStorageAllowedInMemoryOnly];
            
            // NOTE: This currently returns all data in a single shot. A possible future enhancement here
            // would be to update this to support streaming the response data over several calls. This would
            // also allow support for simulating different network speeds more accurately than the current
            // generic `responseDelay` does.
            [client URLProtocol:self didLoadData:data];
            [client URLProtocolDidFinishLoading:self];
        }
    });
}

@end
