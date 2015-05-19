//
//  MMBarricadeResponse.m
//  Barricade
//
//  Created by John McIntosh on 5/12/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import "MMBarricadeResponse.h"


NSString * const MMBarricadeContentTypeHeaderKey = @"Content-Type";


@implementation MMBarricadeResponse

- (id)copyWithZone:(NSZone *)zone {
    MMBarricadeResponse *response = [[[self class] allocWithZone:zone] init];
    response.name = [self.name copyWithZone:zone];
    response.dynamicResponseForRequest = [self.dynamicResponseForRequest copyWithZone:zone];
    response.contentType = [self.contentType copyWithZone:zone];
    response.statusCode = self.statusCode;
    // Don't copy contentString, because it's just a wrapper around contentData
    response.contentData = [self.contentData copyWithZone:zone];
    response.allHeaderFields = [self.allHeaderFields copyWithZone:zone];
    response.error = [self.error copyWithZone:zone];
    return response;
}

- (NSDictionary *)allHeaderFields {
    NSMutableDictionary *headers = [_allHeaderFields mutableCopy] ?: [NSMutableDictionary dictionary];
    if (self.contentType.length > 0) {
        headers[MMBarricadeContentTypeHeaderKey] = self.contentType;
    }
    return headers;
}

- (NSString *)contentType {
    if (_contentType.length > 0) {
        return _contentType;
    }
    return _allHeaderFields[MMBarricadeContentTypeHeaderKey];
}

- (NSString *)contentString {
    return [[NSString alloc] initWithData:self.contentData encoding:NSUTF8StringEncoding];
}

- (void)setContentString:(NSString *)contentString {
    self.contentData = [contentString dataUsingEncoding:NSUTF8StringEncoding];
}

- (id<MMBarricadeResponse>(^)(NSURLRequest *))responseForRequest {
    if (self.dynamicResponseForRequest) {
        return self.dynamicResponseForRequest;
    }
    else {
        id<MMBarricadeResponse>(^responseBlock)(NSURLRequest *) = ^id<MMBarricadeResponse>(NSURLRequest *request) {
            return [self copy];
        };
        return responseBlock;
    }
}

- (NSString *)description {
    return [self debugDescription];
}

- (NSString *)debugDescription {
    if (self.error) {
        return [NSString stringWithFormat:@"<MMBarricadeResponse Error | Domain: %@ | Code: %li>", self.error.domain, (long)self.error.code];
    }
    else {
        return [NSString stringWithFormat:@"<MMBarricadeResponse %li | %@ | %li headers>", (long)self.statusCode, self.name, (long)self.allHeaderFields.allKeys.count];
    }
}

@end