//
//  BannerTableViewController.h
//  BannerView
//
//  Created by Marc Mauger on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IconDownloader.h"
#import "BannerXMLParser.h"
#import "StatsPoster.h"

@class UserStats;

@interface BannerTableViewController : UITableViewController
    <UIScrollViewDelegate, IconDownloaderDelegate, ParseOperationDelegate, 
    PostOperationDelegate>
{
    // Custom cell pointer for loading xib
    UITableViewCell     *tvCell;
    // Data source array
    NSMutableArray      *banners;
    // XML Fetching
    NSMutableData       *xmlData;
    NSURLConnection     *connectionInProgress;
    // Banner icon dowloading
    NSMutableDictionary *imageDownloadsInProgress; // the set of IconDownloader objects for each banner
    // Stats tracking
    UserStats           *userStats;
}
@property (nonatomic, assign) IBOutlet UITableViewCell *tvCell;
@property (nonatomic, retain) NSMutableArray *banners;
@property (nonatomic, retain) NSMutableData *xmlData;
@property (nonatomic, retain) NSURLConnection *connectionInProgress;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) UserStats *userStats;

+ (NSString *)bannersConfigurationPath;
+ (NSString *)statsArchivePath;
- (void)loadBanners;
- (void)didFinishParsing:(NSArray *)appList;
- (void)parseErrorOccurred:(NSError *)error;
- (void)archiveData;
@end
