//
//  IRURLCacheMock.h
//  IRUtil
//
//  Created by Ramesh on 2/21/15.
//
//

// Usage Notes:
//
// NSURLCache must be set prior to invoking any network call.
// For example, this can be set in AppDelegate#didFinishLaunchingWithOptions
//
//  #if defined(DEBUG) // extra guard to protect from production builds
//      Class aClass = NSClassFromString(@"IRURLCacheMock");
//      if (aClass) {
//          [NSURLCache setSharedURLCache:[[aClass alloc] init]];
//      }
//  #endif
//
//

#import <Foundation/Foundation.h>

@interface IRURLCacheMock : NSURLCache

// Sets substitution for given original path by loading contents of file.
// File is located using current class bundle.
- (void)setSubstitutionFile:(NSString *)filename forOriginalPath:(NSString *)originalRESTFullURL;

// Removes the substitution entry for given original path.
- (void)removeSubstitutionForOriginalPath:(NSString *)originalPath;

// Removes all the mappings and cached responses.
- (void)clearAllMappings;

@end
