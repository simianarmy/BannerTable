//
//  BannerXMLParser.m
//  BannerView
//
//  Created by Marc Mauger on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BannerXMLParser.h"
#import "Banner.h"

static NSString *kBannerStr     = @"banner";
static NSString *kBannerIDStr   = @"bannerID";
static NSString *kTitleStr      = @"title";
static NSString *kSubtitleStr   = @"subtitle";
static NSString *kImageURLStr   = @"thumbnailURL";
static NSString *kTargetStr     = @"target";

@implementation BannerXMLParser

@synthesize delegate, dataToParse, workingEntry, workingArray, elementString;

- (id)initWithData:(NSData *)data delegate:(id <ParseOperationDelegate>)theDelegate
{
    self = [super init];
    if (self != nil)
    {
        self.dataToParse = data;
        self.delegate = theDelegate;
        self.workingArray = [NSMutableArray array];

        [self parse];
    }
    return self;
}

- (void)dealloc
{
    [dataToParse release];
    [workingEntry release];
    [workingArray release];
    [elementString release];
    
    [super dealloc];
}

- (void)parse
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.dataToParse];
    
    // We are the delegate
    [parser setDelegate:self];
    
    // Parse everything now
    [parser parse];
    
    if (![self isCancelled])
    {
        // notify our AppDelegate that the parsing is complete
        [self.delegate didFinishParsing:self.workingArray];
    }
    // Done parsing
    [parser release];
}

#pragma mark -
#pragma mark XML processing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    //NSLog(@"Element %@", elementName);
    
    if ([elementName isEqualToString:kBannerStr]) {
        waitingForBannerElement = YES;
        self.workingEntry = [[[Banner alloc] init] autorelease];
    } else if (waitingForBannerElement) {
        elementString = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //NSLog(@"characters: %@", string);
    [elementString appendString:string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
    //NSLog(@"End element: %@", elementName);
    if (self.workingEntry) {
        if ([elementName isEqualToString:kBannerIDStr]) {
            [self.workingEntry setBannerID:elementString];
        } else if ([elementName isEqualToString:kTitleStr]) {
            [self.workingEntry setTitle:elementString];
        } else if ([elementName isEqualToString:kSubtitleStr]) {
            [self.workingEntry setSubtitle:elementString];
        } else if ([elementName isEqualToString:kTargetStr]) {
            [self.workingEntry setClickTargetURL:[NSURL URLWithString:elementString]];
        } else if ([elementName isEqualToString:kImageURLStr]) {
            [self.workingEntry setThumbnailURL:[NSURL URLWithString:elementString]];
        } else if ([elementName isEqualToString:kBannerStr]) {
            waitingForBannerElement = NO;
            [self.workingArray addObject:self.workingEntry];
            self.workingEntry = nil;
        }
    }
}


@end
