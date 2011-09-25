//
//  UserStats.h
//  BannerView
//
//  Created by Marc Mauger on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserStats : NSObject <NSCoding>
{
    NSMutableDictionary *stats;
}
@property (nonatomic, retain) NSMutableDictionary *stats;

- (void)reset;
- (void)didClickInfoIcon;
- (void)didClickTabButton;
- (void)didClickTableCell;
- (NSUInteger)total;
- (NSString *)queryString;
@end
