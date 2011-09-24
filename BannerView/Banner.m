//
//  Banner.m
//  BannerView
//
//  Created by Marc Mauger on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Banner.h"

@implementation Banner
@synthesize bannerID;
@synthesize title;
@synthesize subtitle;
@synthesize clickTargetURL;
@synthesize thumbnail;
@synthesize thumbnailURL;

- (id)init
{
    self = [super init];
    if (self) {
        self.bannerID           = nil;
        self.title              = nil;
        self.subtitle           = nil;
        self.clickTargetURL     = nil;
        self.thumbnailURL       = nil;
        self.thumbnail          = nil;
    }
    return self;
}

- (void)dealloc
{
    [bannerID release];
    [title release];
    [subtitle release];
    [clickTargetURL release];
    [thumbnail release];
    [thumbnailURL release];

    [super dealloc];
}

- (NSString *)thumbnailURLString
{
    return [self.thumbnailURL absoluteString];
}

// Useful for generating image cache key from thumbnail url
- (NSString *)thumbnailCacheKey
{
    return [[self thumbnailURLString] lastPathComponent];
}

#pragma mark -
#pragma mark NSCoding Methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:bannerID forKey:@"bannerID"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:subtitle forKey:@"subtitle"];
    [aCoder encodeObject:clickTargetURL forKey:@"clickTargetURL"];
    [aCoder encodeObject:thumbnailURL forKey:@"thumbnailURL"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [super init];
    [self setBannerID:[aDecoder decodeObjectForKey:@"bannerID"]];
    [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
    [self setSubtitle:[aDecoder decodeObjectForKey:@"subtitle"]];
    [self setClickTargetURL:[aDecoder decodeObjectForKey:@"clickTargetURL"]];
    [self setThumbnailURL:[aDecoder decodeObjectForKey:@"thumbnailURL"]];
    
    return self;
}

@end
