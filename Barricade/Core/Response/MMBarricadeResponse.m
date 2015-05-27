//
//  MMBarricadeResponse.m
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

#import "MMBarricadeResponse.h"


NSString * const MMBarricadeContentTypeHeaderKey = @"Content-Type";


@implementation MMBarricadeResponse

- (id)copyWithZone:(NSZone *)zone {
    MMBarricadeResponse *response = [[[self class] allocWithZone:zone] init];
    response.name = self.name;
    response.dynamicResponseForRequest = self.dynamicResponseForRequest;
    response.contentType = self.contentType;
    response.statusCode = self.statusCode;
    // Don't copy contentString, because it's just a wrapper around contentData
    response.contentData = self.contentData;
    response.allHeaderFields = self.allHeaderFields;
    response.error = [self.error copyWithZone:zone];
    return response;
}

- (NSDictionary *)allHeaderFields {
    NSMutableDictionary *headers = [_allHeaderFields mutableCopy] ?: [NSMutableDictionary dictionary];
    if (self.contentType.length > 0) {
        headers[MMBarricadeContentTypeHeaderKey] = self.contentType;
    }
    return [headers copy];
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