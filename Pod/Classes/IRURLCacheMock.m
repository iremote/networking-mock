//
//  IRURLCacheMock.m
//  IRNetworkingMock
//
//  Created by Ramesh on 2/21/15.
//
//

#import "IRURLCacheMock.h"

@interface IRURLCacheMock ()
@property (nonatomic, strong) NSMutableDictionary *mappings;
@property (nonatomic, strong) NSCache *cachedResponses;
@end

@implementation IRURLCacheMock

#pragma mark - Instance methods

- (instancetype)init {
    self = [super init];
    if (self) {
        _mappings = [[NSMutableDictionary alloc] init];
        _cachedResponses = [[NSCache alloc] init];
    }
    return self;
}

- (void)given:(NSString *)HTTPMethod URLString:(NSString *)URLString respondWithFileContent:(NSString *)filename {
    [self.mappings setObject:filename forKey:[IRURLCacheMock normalizedKeyForHTTPMethod:HTTPMethod andURLString:URLString]];
}

- (void)clearAllMappings {
    [self.mappings removeAllObjects];
    [self.cachedResponses removeAllObjects];
    [self removeAllCachedResponses];
}

#pragma mark - Override methods

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    
    //
    // Get RESTFull URI path fromoriginal request
    //
    
    // trim any attributes from path (like ?timestamp=13131)
    NSString *URLString = [[[[request URL] absoluteString] componentsSeparatedByString:@"?"] firstObject];
    NSString *requestKey = [IRURLCacheMock normalizedKeyForHTTPMethod:request.HTTPMethod andURLString:URLString];
    
    if (![@"GET" isEqualToString:request.HTTPMethod]) {
        NSLog(@"[%@] %@ %@", NSStringFromClass([self class]), requestKey, request.HTTPBody);
    }
    
    //
    // See if substitution file exists for given path
    //
    
    NSString *substitutionFilename = [self.mappings objectForKey:requestKey];
    if (nil == substitutionFilename) {
        // Return the default cache as there is no mapping set for given path
        return [super cachedResponseForRequest:request];
    }
    
    //
    // Check if we have already created the cached entry that we can return
    //
    
    NSCachedURLResponse *cachedResponse = [self.cachedResponses objectForKey:requestKey];
    if (cachedResponse) {
        return cachedResponse;
    }
    
    //
    // Create cacheable response from give file data
    //
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:[substitutionFilename stringByDeletingPathExtension]
                                          ofType:[substitutionFilename pathExtension]];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSAssert(filePath, @"Cannot find filePath for resource/%@", substitutionFilename);
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:request.URL
                                                        MIMEType:@"application/json"
                                           expectedContentLength:[data length] textEncodingName:nil];
    
    cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
    
    //
    // Add it to cached responses (for future use)
    //
    
    [self.cachedResponses setObject:cachedResponse forKey:requestKey];
    
    //
    // Return cached response
    //
    
    return cachedResponse;
}

#pragma mark - Private methods

+ (NSString *)normalizedKeyForHTTPMethod:(NSString *)HTTPMethod andURLString:(NSString *)URLString {
    return [NSString stringWithFormat:@"%@ %@", HTTPMethod, URLString];
}

@end
