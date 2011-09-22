//
//  BannerTableViewController.h
//  BannerView
//
//  Created by Marc Mauger on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IconDownloader.h"
#import "BannerXMLParser.h"

@interface BannerTableViewController : UITableViewController
    <UIScrollViewDelegate, IconDownloaderDelegate, ParseOperationDelegate>
{
    NSArray  *banners;
    // XML Fetching
    NSMutableData *xmlData;
    NSURLConnection *connectionInProgress;
    // Banner icon dowloading
    NSMutableDictionary *imageDownloadsInProgress; // the set of IconDownloader objects for each banner
}
@property (nonatomic, retain) NSArray *banners;
@property (nonatomic, retain) NSMutableData *xmlData;
@property (nonatomic, retain) NSURLConnection *connectionInProgress;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

-(void)loadBanners;
- (void)didFinishParsing:(NSArray *)appList;
- (void)parseErrorOccurred:(NSError *)error;

@end
