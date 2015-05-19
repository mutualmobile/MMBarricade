//
//  MMBarricadeResponse.h
//  Barricade
//
//  Created by John McIntosh on 5/12/15.
//  Copyright (c) 2015 Mutual Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT NSString * const MMBarricadeContentTypeHeaderKey;


/**
 A concrete implementation of `<MMBarricadeResponse>` represents a single response that can be returned
 from the barricade, and should be thought of as a replication of what your server might return as
 the response to an API request.
 
 This protocol makes no assumption about where the content of the response comes from. For example,
 `MMBarricadeInlineResponse` provides the ability for the developer to manually set the body of the
 response in code, and `MMBarricadeFileResponse` provides the ability to easily populate the body of
 the response with the content of a file in the app bundle. Feel free to create additional concrete
 implementations of this protocol for your own needs.
 */
@protocol MMBarricadeResponse <NSObject>

/**
 The name represents the string name used to identify this request in the context of your app. It is
 for the developer's use only.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 The HTTP status code associated with the response. For exapmle, 200 typically represents a standard,
 successful response.
 */
@property (nonatomic, assign, readonly) NSInteger statusCode;

/**
 NSData representation of the response body.
 */
@property (nonatomic, copy, readonly) NSData *contentData;

/**
 A dictionary containing all the HTTP header fields in the response.
 */
@property (nonatomic, copy, readonly) NSDictionary *allHeaderFields;

/**
 An error representing the response. If an error is specified, all other properties will be ignored
 and the resposne will be processed using the error.
 */
@property (nonatomic, strong, readonly) NSError *error;

/**
 MMBarricade will call this method on a Resonse object and will use its return value for populating
 the network response that is returned from the barricade. Simple implementations of this protocol
 can implement this method to just return a copy of the existing request:

 ```
 - (id<MMBarricadeResponse>(^)(NSURLRequest *))responseForRequest {
     id<MMBarricadeResponse>(^responseBlock)(NSURLRequest *) = ^id<MMBarricadeResponse>(NSURLRequest *request) {
         return [self copy];
     };
     return responseBlock;
 }
 ```

 More advanced implementations of the protocol could implement this method as a hook to inject dynamic
 data into the response object before returning it to the called. For example, this could be used to
 set the `date` field of a JSON property in the response so that it is always today's date, whereas
 if the response is simply returning a static JSON  file, the date would not dynamically change.
 */
- (id<MMBarricadeResponse>(^)(NSURLRequest *))responseForRequest;

@end


/**
 MMBarricade response is the default concrete implemention of <MMBarricadeResponse>. It can be used
 directly for most applications, or can be subclassed for special circumstances.
 */
@interface MMBarricadeResponse : NSObject <MMBarricadeResponse, NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, copy) NSData *contentData;
@property (nonatomic, copy) NSDictionary *allHeaderFields;
@property (nonatomic, strong) NSError *error;

/**
 Convenience property for reading/setting the "Content-Type" header field. Setting this value internally
 updates the 'Content-Type' value in the `allHeaderFields` dictionary.
 */
@property (nonatomic, copy) NSString *contentType;

/**
 Convenience property for reading/setting string values into the `contentData` property of the response.
 The `contentString` and `contentData` properties share a backing store, so they will cannot be set
 to different values.
 */
@property (nonatomic, copy) NSString *contentString;

/**
 Add a block for applying custom modifications to the response just before returning it through the
 network.
 */
@property (nonatomic, copy) id<MMBarricadeResponse> (^dynamicResponseForRequest)(NSURLRequest *request);

@end