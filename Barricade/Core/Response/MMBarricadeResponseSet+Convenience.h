//
//  MMBarricadeResponseSet+Convenience.h
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

#import "MMBarricadeResponseSet.h"


@interface MMBarricadeResponseSet (Convenience)

///--------------------------------
/// @name Errors
///--------------------------------

/**
 Return a response instance containing the provided error.
 */
- (MMBarricadeResponse *)addResponseWithName:(NSString *)name error:(NSError *)error;

///--------------------------------
/// @name JSON
///--------------------------------

/**
 Return a response instance populated with a JSON object. If there is an error serializing the JSON
 object, the response's `error` property will be populated with the error. The Content-Type header of
 the response will be set to the value of `contentType`.
 */
- (MMBarricadeResponse *)addResponseWithName:(NSString *)name
                                        JSON:(id)JSON
                                  statusCode:(NSInteger)statusCode
                                 contentType:(NSString *)contentType;

/**
 Return a response instance populated with a JSON object. If there is an error serializing the JSON
 object, the response's `error` property will be populated with the error.
 */
- (MMBarricadeResponse *)addResponseWithName:(NSString *)name
                                        JSON:(id)JSON
                                  statusCode:(NSInteger)statusCode
                                     headers:(NSDictionary *)headers;


///--------------------------------
/// @name Files
///--------------------------------

/**
 Return a response instance populated with the contents of a file. If there is an error reading the
 file, the response's `error` property will be populated with the error. The Content-Type header of
 the response will be set to the value of `contentType`.
 */
- (MMBarricadeResponse *)addResponseWithName:(NSString *)name
                                        file:(NSString *)filePath
                                  statusCode:(NSInteger)statusCode
                                 contentType:(NSString *)contentType;

/**
 Return a response instance populated with the contents of a file. If there is an error reading the
 file, the response's `error` property will be populated with the error.
 */
- (MMBarricadeResponse *)addResponseWithName:(NSString *)name
                                        file:(NSString *)filePath
                                  statusCode:(NSInteger)statusCode
                                     headers:(NSDictionary *)headers;

///--------------------------------
/// @name Raw Data
///--------------------------------

/**
 Return a response instance populated with raw data. The Content-Type header of the response will be
 set to the value of `contentType`.
 */
- (MMBarricadeResponse *)addResponseWithName:(NSString *)name
                                        data:(NSData *)data
                                  statusCode:(NSInteger)statusCode
                                 contentType:(NSString *)contentType;

/**
 Return a response instance populated with raw data.
 */
- (MMBarricadeResponse *)addResponseWithName:(NSString *)name
                                        data:(NSData *)data
                                  statusCode:(NSInteger)statusCode
                                     headers:(NSDictionary *)headers;

@end
