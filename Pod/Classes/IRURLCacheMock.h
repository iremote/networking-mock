//
//  IRURLCacheMock.h
//  IRNetworkingMock
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

// Given HTTP request (Method & URL) respond with content of given file.
// File is located using current class bundle.
- (void)given:(NSString *)HTTPMethod URLString:(NSString *)URLString respondWithFileContent:(NSString *)filename;

// Removes all the mappings and cached responses.
- (void)clearAllMappings;

@end
