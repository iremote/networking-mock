//
//  IRURLCacheMock.m
//  Pods
//
//  Created by Ramesh on 2/21/15.
//
//

#import "IRURLCacheMock.h"

@interface IRURLCacheMock ()
@property (nonatomic, strong) NSMutableDictionary *mappings;
@property (nonatomic, strong) NSMutableDictionary *cachedResponses;
@end

@implementation IRURLCacheMock

#pragma mark - Instance methods

- (instancetype)init {
    self = [super init];
    if (self) {
        _mappings = [[NSMutableDictionary alloc] init];
        _cachedResponses = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setSubstitutionFile:(NSString *)filename forOriginalPath:(NSString *)originalRESTFullURL {
    [self.mappings setValue:filename forKey:originalRESTFullURL];
}

- (void)removeSubstitutionForOriginalPath:(NSString *)originalRESTFullURL {
    [self.mappings removeObjectForKey:originalRESTFullURL];
}

#pragma mark - Override methods

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    
    //
    // Get RESTFull URI path fromoriginal request
    //
    
    NSString *pathString = [[request URL] absoluteString];
    // trim any attributes from path (like ?timestamp=13131)
    pathString = [[pathString componentsSeparatedByString:@"?"] firstObject];
    
    //
    // See if substitution file exists for given path
    //
    
    NSString *substitutionFilename = [self.mappings objectForKey:pathString];
    if (nil == substitutionFilename) {
        // Return the default cache as there is no mapping set for given path
        return [super cachedResponseForRequest:request];
    }
    
    //
    // Check if we have already created the cached entry that we can return
    //
    
    NSCachedURLResponse *cachedResponse = [self.cachedResponses objectForKey:pathString];
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
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:request.URL
                                                        MIMEType:@"application/json"
                                           expectedContentLength:[data length] textEncodingName:nil];
    
    cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
    
    //
    // Add it to cached responses (for future use)
    //
    
    [self.cachedResponses setObject:cachedResponse forKeyedSubscript:pathString];
    
    //
    // Return cached response
    //
    
    return cachedResponse;
}

- (void)clearAllMappings {
    
    [self.mappings removeAllObjects];
    [self.cachedResponses removeAllObjects];
}

@end
