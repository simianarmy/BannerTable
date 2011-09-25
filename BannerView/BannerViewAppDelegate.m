//
//  BannerViewAppDelegate.m
//  BannerView
//
//  Created by Marc Mauger on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BannerViewAppDelegate.h"
#import "BannerTableViewController.h"
#import "UserStats.h"

NSString *AppDataDownloadCompleted = @"AppDataDownloadCompleted";

@implementation BannerViewAppDelegate

@synthesize window = _window;
@synthesize bannerTableController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *archivePath = [BannerTableViewController bannersConfigurationPath];
    
    NSMutableArray *banners = 
        [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    
    NSLog(@"Unarchived %d banners", [banners count]);
    if (!banners) {
        banners = [NSMutableArray array];
    }
    bannerTableController = [[BannerTableViewController alloc] init];
    
    [bannerTableController setBanners:banners];
    
    // Unarchive and assign stats object
    archivePath = [BannerTableViewController statsArchivePath];
    //NSLog(@"Unarchiving stats from %@", archivePath);
    UserStats *stats = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    if (!stats)
    {
        stats = [[UserStats alloc] init];
    }
    [bannerTableController setUserStats:stats];
    
    [self.window setRootViewController:bannerTableController];    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [bannerTableController archiveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [bannerTableController archiveData];
}

- (void)dealloc
{
    [_window release];
    [bannerTableController release];
    [super dealloc];
}


@end
