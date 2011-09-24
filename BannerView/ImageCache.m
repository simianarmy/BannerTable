//
//  ImageCache.m
//  BannerView
//
//  Created by Marc Mauger on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageCache.h"
#import "FileHelpers.h"

static ImageCache *sharedImageCache;

@implementation ImageCache

- (id)init
{
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark Accessing the cache

- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
    
    // Create full page for image
    NSString *imagePath = pathInCachesDirectory(s);
    
    // Turn image into data (PNG)
    NSData *data = UIImagePNGRepresentation(i);
    
    // Write it to full path
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)s
{
    if (!s) return nil;

    // Get from RAM if possible
    UIImage *result = [dictionary objectForKey:s];
    
    if (!result) {
        // Create image from file
        result = [UIImage imageWithContentsOfFile:pathInCachesDirectory(s)];
        // Save to cache if found
        if (result) {
            [dictionary setObject:result forKey:s];
        } else {
            NSLog(@"Unable to find image file: %@", pathInCachesDirectory(s));
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)s
{
    [dictionary removeObjectForKey:s];
    NSString *imagePath = pathInCachesDirectory(s);
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

#pragma mark Singleton methods

+ (ImageCache *)sharedImageCache
{
    if (!sharedImageCache) {
        sharedImageCache = [[ImageCache alloc] init];
    }
    return sharedImageCache;
}

+ (id)allocWithZone:(NSZone *)zone
{
    if (!sharedImageCache) {
        sharedImageCache = [super allocWithZone:zone];
        return sharedImageCache;
    } else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)release
{
    // Nothing
}

@end
