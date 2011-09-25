//
//  BannerViewAppDelegate.h
//  BannerView
//
//  Created by Marc Mauger on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerTableViewController;

extern NSString *AppDataDownloadCompleted;

@interface BannerViewAppDelegate : NSObject <UIApplicationDelegate>
{
    BannerTableViewController *bannerTableController;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) BannerTableViewController *bannerTableController;

@end
