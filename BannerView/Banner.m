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

@end
