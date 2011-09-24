//
//  BannerTableViewController.m
//  BannerView
//
//  Created by Marc Mauger on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BannerViewAppDelegate.h"
#import "BannerTableViewController.h"
#import "Banner.h"
#import "BannerXMLParser.h"
#import "ImageCache.h"
#import "FileHelpers.h"

// These settings modify the look of the banner cells.
// Use these values if you do not use the cell XIB
#define kCustomRowHeight    65
#define kCustomRowCount     7
#define kCellIndentationLevel   1
#define kCellIndentationWidth   1

// Set this to the minimum number of seconds interval between banner config
// server requests.  Smaller values = higher network load on banner server.
#define kBannerConfigExpirySeconds 86400 // 24 hours

// The permanent file for storing the latest banner config download date
static NSString *const BannerConfigFile =
    @"BannerConfigDate.info";

// The one and only API endpoint for the banners xml data.  
// Use a domain name, not an IP to prevent bricking your apps.
static NSString *const BannerDataAPIURL = 
    @"http://sportfanapi.local/xml/banners.xml";

@interface BannerTableViewController ()
- (void)startIconDownload:(Banner *)banner forIndexPath:(NSIndexPath *)indexPath;
- (void)handleLoadError:(NSString *)errorMessage;
- (BOOL)bannerConfigurationDidExpire;
- (NSDate *)bannersConfigurationDate;
- (void)bannersConfigurationDate:(NSDate *)date;
@end

@implementation BannerTableViewController
@synthesize tvCell;
@synthesize banners;
@synthesize imageDownloadsInProgress;
@synthesize xmlData;
@synthesize connectionInProgress;

// Use plain initializer to use UITableViewStylePlain table view style
- (id)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

// Use default initializer to customize the table view style
- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    }
    return self;
}

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

- (void)dealloc
{
    [banners release];
    [imageDownloadsInProgress release];
    [connectionInProgress release];
    [xmlData release];
    
    [super dealloc];
}

// @returns last time banner configuration was downloaded (or nil if never).
- (NSDate *)bannersConfigurationDate
{
    NSString *dateStr = [[NSString alloc] 
                         initWithContentsOfFile:pathInDocumentDirectory(BannerConfigFile)];
    if (!dateStr) {
        return nil;
    }
    NSLog(@"Read config date: %@", dateStr);
    
    NSDate *configDate = [NSDate dateWithTimeIntervalSince1970:[dateStr floatValue]];

    [dateStr release];
    
    return configDate;
}

// Saves the latest banners configuration download date to permanent storage
- (void)bannersConfigurationDate:(NSDate *)date
{
    NSString *dt = [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    NSLog(@"Saving date: %@", dt);
    
    [dt writeToFile:pathInDocumentDirectory(BannerConfigFile)
              atomically:YES 
                encoding:NSUTF8StringEncoding 
                   error:nil];
}

// @returns TRUE if our banner configuration is stale
- (BOOL)bannerConfigurationDidExpire
{
    // Get last config load time 
    NSDate *lastSaved = [self bannersConfigurationDate];
    if (!lastSaved) {
        return YES; // Expired if no previous save date
    }
    return [lastSaved compare:[NSDate dateWithTimeIntervalSinceNow:-kBannerConfigExpirySeconds]] == NSOrderedAscending;
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    if (([banners count] == 0) || [self bannerConfigurationDidExpire]) {
        [self loadBanners];
    } 
    [super viewDidLoad];
}

/*
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Loading xml

- (void)loadBanners
{
    // Reduce network requests by caching the data for some configurable time period
    NSURL *url = [NSURL URLWithString:BannerDataAPIURL];
    NSURLRequest *request = 
    [NSURLRequest requestWithURL:url
                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                 timeoutInterval:10];
    
    if (connectionInProgress) {
        [connectionInProgress cancel];
        [connectionInProgress release];
    } 
    [xmlData release];
    xmlData = [[NSMutableData alloc] init];
    
    connectionInProgress = [[NSURLConnection alloc] initWithRequest:request
                                                    delegate:self
                                            startImmediately:YES];

    // show in the status bar that network activity is starting
    if (connectionInProgress) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

- (void)didFinishParsing:(NSArray *)tableData
{
    // Don't mess with existing data if parsing didn't return anything
    if ([tableData count] > 0) {
        // Make sure to clear any existing banner data
        [banners removeAllObjects];
        
        [self.banners addObjectsFromArray:tableData];
        [[self tableView] reloadData];
    }
}

- (void)parseErrorOccurred:(NSError *)error
{
    [self handleLoadError:[error localizedDescription]];
}

- (void)handleLoadError:(NSString *)errorMessage
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Show Banners"
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark -
#pragma mark Table Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCustomRowHeight;
}

#pragma mark - 
#pragma mark UITableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    int count = [banners count];
	
	// if there's no data yet, return enough rows to fill the screen
    if (count == 0)
	{
        return kCustomRowCount;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // customize the appearance of table view cells
	//
	static NSString *CellIdentifier = @"BannerCell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
    int nodeCount = [self.banners count];
	
	if (nodeCount == 0 && indexPath.row == 0)
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil)
		{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
										   reuseIdentifier:PlaceholderCellIdentifier] autorelease];   
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
		cell.detailTextLabel.text = @"Loading…";
		
		return cell;
    }

    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = tvCell;
        self.tvCell = nil;
        /*
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:CellIdentifier] autorelease];
         */
    }
    // Leave cells empty if there's no data yet
    if (nodeCount > 0) {
        Banner *banner = [self.banners objectAtIndex:[indexPath row]];

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label;
        label = (UILabel *)[cell viewWithTag:1];
        label.text = banner.title;
        // *** HACK: Force vertical align: top
        label.numberOfLines = 1;
        label.frame = CGRectMake(69, 2, 196, 24);
        [label sizeToFit];
        
        
        label = (UILabel *)[cell viewWithTag:2];
        label.text = banner.subtitle;

        /* 
         * I'm leaving the original cell label code in case you don't want to use the NIB method
         * Indentation is defined in the NIB
        cell.indentationLevel = kCellIndentationLevel;
        cell.indentationWidth = kCellIndentationWidth;
         
        // Set text labels' attributes here.
        cell.textLabel.text = banner.title;
        cell.textLabel.font = [UIFont fontWithName:@"Arial-Bold" size:16];
        cell.detailTextLabel.text = banner.subtitle;
        cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:11];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        */
        
        // Only load cached images; defer new downloads until scrolling ends
        UIImage *thumb = [[ImageCache sharedImageCache] imageForKey:banner.thumbnailCacheKey];
        if (!thumb) {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
                if (banner.thumbnailURL) {
                    [self startIconDownload:banner forIndexPath:indexPath];
                }
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];                
        } else {
            cell.imageView.image = thumb;
        }
    }        
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.row % 2) {
        //#C2C2C2
        cell.backgroundColor = [UIColor colorWithRed:194.0/255 green:194.0/255 blue:194.0/255 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Banner *banner = [banners objectAtIndex:[indexPath row]];
    NSLog(@"Banner clicked with target: %@", [[banner clickTargetURL] absoluteURL]);
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

#pragma mark - 
#pragma mark NSURLConnection delegate methods

- (void)handleError:(NSError *)error
{
    [self handleLoadError:[error localizedDescription]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.xmlData = [NSMutableData data];    // start off with new data
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [xmlData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([error code] == kCFURLErrorNotConnectedToInternet)
	{
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No Connection Error"
															 forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
														 code:kCFURLErrorNotConnectedToInternet
													 userInfo:userInfo];
        [self handleError:noConnectionError];
    }
	else
	{
        // otherwise handle the error generically
        [self handleError:error];
    }
    self.connectionInProgress = nil;
    self.xmlData = nil;   // release our connection
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.connectionInProgress = nil;
    
    // Save the config download date
    [self bannersConfigurationDate:[NSDate date]];
    
    // Start parsing the downloaded data
    [[[BannerXMLParser alloc] initWithData:xmlData delegate:self] autorelease];
        
    self.xmlData = nil;
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(Banner *)banner forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.banner = banner;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their banner icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.banners count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Banner *banner = [self.banners objectAtIndex:indexPath.row];
            
            if (!banner.thumbnail) // avoid the icon download if the banner already has an icon
            {
                [self startIconDownload:banner forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = [[ImageCache sharedImageCache] imageForKey:iconDownloader.banner.thumbnailCacheKey];
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

- (void)downloadCompleted:(NSNotification *)notification
{
    self.banners = [notification object];   // incoming object is an NSArray of banners
    [self.tableView reloadData];
}

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

@end
