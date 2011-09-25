//
//  UserStats.m
//  BannerView
//
//  Created by Marc Mauger on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserStats.h"

#define kTabClickKey    @"tabClicks"
#define kInfoClickKey   @"infoClicks"
#define kBannerClickKey @"bannerClicks"

@interface UserStats ()
- (void)incrementStat:(NSString *)key;
- (NSString *)queryString;
@end

@implementation UserStats
@synthesize stats;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.stats = [[NSMutableDictionary alloc] init];
        [self reset];
    }
    
    return self;
}

// Zeros all stats values
- (void)reset
{
    NSNumber *tab    = [NSNumber numberWithUnsignedInt:0];
    NSNumber *info   = [NSNumber numberWithUnsignedInt:0];
    NSNumber *banner = [NSNumber numberWithUnsignedInt:0];
    
    [stats setObject:tab forKey:kTabClickKey];
    [stats setObject:info forKey:kInfoClickKey];
    [stats setObject:banner forKey:kBannerClickKey];
}

// Increment counter for a single stat
- (void)incrementStat:(NSString *)key
{
    // Update value object 
    NSUInteger count = (NSUInteger)[[stats objectForKey:key] intValue];
    NSNumber *newval = [NSNumber numberWithUnsignedInt:count+1];
    [stats setObject:newval forKey:key];
}

// @returns SUM of values
- (NSUInteger)total
{
    // TODO: Figure out KVC & use @sum
    NSUInteger tot = 0;
    for (NSNumber *num in [stats allValues]) {
        tot += [num intValue];
    }
    NSLog(@"Stats total: %d", tot);
    return tot;
}

// Returns stats as query string (for submitting to web server)
- (NSString *)queryString
{
    NSMutableString *str = [[[NSMutableString alloc] initWithString:@""] autorelease];
    for (NSString *key in [stats allKeys]) {
        [str appendFormat:@"%@=%d&", key, [[stats objectForKey:key] intValue]];
    }
    return str;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)dealloc
{
    [stats release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark User Action Tracking Methods

// Click action helper methods:
// They all increment the counter for some action stat

- (void)didClickInfoIcon
{
    [self incrementStat:kInfoClickKey];
}

- (void)didClickTabButton
{
    [self incrementStat:kTabClickKey];
}

- (void)didClickTableCell
{
    [self incrementStat:kBannerClickKey];
}
 

#pragma mark -
#pragma mark NSCoding Methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:stats forKey:@"stats"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.stats = [aDecoder decodeObjectForKey:@"stats"];
    
    return self;
}

@end
