//
//  ImageCache.h
//  BannerView
//
//  Created by Marc Mauger on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCache : NSObject
{
    NSMutableDictionary *dictionary;
}
+ (ImageCache *)sharedImageCache;
- (void)setImage:(UIImage *)i forKey:(NSString *)s;
- (UIImage *)imageForKey:(NSString *)s;
- (void)deleteImageForKey:(NSString *)s;
@end
