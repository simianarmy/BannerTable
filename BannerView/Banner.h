//
//  Banner.h
//  BannerView
//
//  Created by Marc Mauger on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Banner : NSObject <NSCoding>
{
    NSString *bannerID;
    NSString *title;
    NSString *subtitle;
    NSURL    *clickTargetURL;
    UIImage  *thumbnail;
    NSURL    *thumbnailURL;
}
@property (nonatomic, retain) NSString *bannerID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSURL    *clickTargetURL;
@property (nonatomic, retain) UIImage  *thumbnail;
@property (nonatomic, retain) NSURL    *thumbnailURL;

- (NSString *)thumbnailURLString;
- (NSString *)thumbnailCacheKey;
@end
