//
//  MMBarricade+Tweaks.h
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


/**
 The tweaks extension of MMBarricade integrates the barricade with Facebook Tweaks to create an 
 in-app menu the user can use to adjust network responses at runtime. 
 
 For example, when implementing a pull-to-refresh feature, this could be used to test all possible 
 network responses of the refresh to see how the UI responds without needing to ever relaunch the app.
 */
@interface MMBarricade (Tweaks)

/**
 Configure the barricade to use a Tweaks-based response store. This store is persisted between application
 launches and automatically builds a section in the Tweaks UI for viewing and choosing responses.
 */
+ (void)setupWithTweaksResponseStore;

@end
