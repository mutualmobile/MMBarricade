//
//  MMBarricadePathUtility.h
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

#import <Foundation/Foundation.h>


/**
 Return the path on disk to a file in the root of the application's main bundle.
 */
NSString * MMPathForFileInMainBundle(NSString *filename);

/**
 Return the path on disk to a file located in a subdirectory of the application's main bundle.
 For example, you might use this if you add a resource directory to your project as a folder reference 
 (which will preserve the directory hierarchy in the app bundle).
 */
NSString * MMPathForFileInMainBundleDirectory(NSString *filename, NSString *directory);

/**
 Return the path on disk to a file in the root of a specific bundle.
 */
NSString * MMPathForFileInBundle(NSString *filename, NSBundle *bundle);

/**
 Return the path on disk to a file located in a subdirectory of a specific bundle.
 */
NSString * MMPathForFileInDirectoryInBundle(NSString *filename, NSString *directory, NSBundle *bundle);

/**
 Return the path on disk to a file in the user's documents directory.
 */
NSString * MMPathForFileInDocumentsDirectory(NSString *filename);