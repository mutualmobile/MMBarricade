# MMBarricade

Robust apps respond well in all network scenarios. It's not feasible to update a live server each time you want to test different network scenarios, so simulate them all within your app.

MMBarricade provides a framework for helping developers setup a run-time configurable local server in their iOS apps. Local servers are beneficial for developing and testing network communication by removing the dependency on a live server.

One of the barricade's most useful features is its ability to integrate with [Facebook Tweaks](https://github.com/facebook/Tweaks) to provide an in-app interface for adjusting server responses at run-time. This makes it simple to test dynamically changing network scenarios without the need to configure a server to recreate the particular test conditions.

<p align="center">
<img src="ReadmeResources/MMBarricade.gif") alt="Example App"/>
</p>

## Example

```objective-c
// Setup the barricade
[MMBarricade setupWithTweaksResponseStore];
[MMBarricade enable];

// Create a response set
MMBarricadeResponseSet *responseSet = [MMBarricadeResponseSet responseSetForRequestName:@"Login" respondsToRequest:^BOOL(NSURLRequest *request, NSURLComponents *components) {
    return [components.path hasSuffix:@"/login"];
}];

// Add Successful response to the set
[responseSet createResponseWithBlock:^id<MMBarricadeResponse>{
        return [MMBarricadeResponse responseWithName:@"success"
                                                file:MMPathForFileInMainBundleDirectory(@"login.success.json", @"LocalServer");
                                          statusCode:200
                                         contentType:@"application/json"];
}];

// Add Invalid Credentials response to the set
[responseSet createResponseWithBlock:^id<MMBarricadeResponse>{
        return [MMBarricadeResponse responseWithName:@"invalid credentials"
                                                file:MMPathForFileInMainBundleDirectory(@"login.invalid.json", @"LocalServer");
                                          statusCode:400
                                         contentType:@"application/json"];

}];

// Add No Network Connection response to the set
[responseSet createResponseWithName:@"offline" populationBlock:^(MMBarricadeResponse *response) {
    response.error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil];
}];

// Register the response set
[MMBarricade registerResponseSet:responseSet];

```

## Getting Started

- Install MMBarricade via CocoaPods or by downloading the Source files
- Configure MMBarricade for your desired resposnes



##Installing MMBarricade
<img src="https://cocoapod-badges.herokuapp.com/v/MMBarricade/badge.png"/><br/>
You can install Barricade in your project by using [CocoaPods](https://github.com/cocoapods/cocoapods):

```Ruby
pod 'MMBarricade', '~> 1.0.0'
```

## Configuration

Configuration consists of two steps:

1. Setup a response store
2. Enable the barricade

The barricade must be configured with an instance of an `<MMBarricadeResponseStore>` before it can be used. To use one of the included response stores, you can:

```objective-c
[MMBarricade setupWithTweaksResponseStore];
-or-
[MMBarricade setupWithInMemoryResponseStore];
```

Once the backing store for the barricade is setup, it should be enabled. Because the barricade works as a [NSURLProtocol](https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Reference/Foundation/Classes/NSURLProtocol_Class/index.html) subclass, the way to enable it differs depending on how you will be making network requests in your app.

**NSURLConnection**

For networking based on the older networking style of NSURLConnection-based requests, simply calling `[MMBarricade enable]` will register the NSURLProtocol for you.

**NSURLSession**

For networking based on the newer NSURLSession-based APIs, you have two options:

If you are using `[NSURLSession sharedSession]`, then you can enable with `[MMBarricade enable]`.

If you are creating a custom session, for example `[NSURLSession sessionWithConfiguration:configuration]`, then you should enable the barricade with your custom session configuration before creating the session.

```objective-c
NSURLSessionConfiguration *configuration = [self myCustomSessionConfiguration];
[MMBarricade enableForSessionConfiguration:configuration];
NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
...
```


## Usage
### Tweaks

The [Facebook Tweaks](https://github.com/facebook/Tweaks) library provides an in-app UI for adjusting parameters of the app at runtime. Barricade integrates with Tweaks to provide an in-app UI for adjusting network responses at runtime.

If you do not wish to include Tweaks integration in your project, you can choose to install just the Core implementation by using `pod 'MMBarricade/Core` in your podfile.

### Changing the response

The response that will be returned by the barricade when a request is made is the "current response" that has been selected in the `MMBarricadeResponseSet` for the request. In addition to updating the current response through the tweaks UI, the response can also be updated programmatically:

```objective-c
[MMBarricade selectResponseForRequest:@"login" withName:@"offline"];
```

### Unit Tests

Take a look at the unit tests in `MMBarricadeTests.m` of `DevelopmentApp/Barricade.xcworkspace` for several examples of how unit tests can be implemented utilizing Barricade.


## Requirements

MMBarricade requires iOS 7.0 or higher.


## Credits

MMBarricade was created by [John McIntosh](http://twitter.com/johntmcintosh) at [Mutual Mobile](http://www.mutualmobile.com).

Credit also to [Justin Kolb](https://github.com/jkolb) for pioneering the concept of run-time adjustable network responses and [Conrad Stoll](http://twitter.com/conradstoll) for feedback.

## License

MMBarricade is available under the MIT license. See the LICENSE file for more info.