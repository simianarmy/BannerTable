//
//  BannerXMLParser.h
//  BannerView
//
//  Created by Marc Mauger on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@class Banner;

@protocol ParseOperationDelegate;

@interface BannerXMLParser : NSOperation <NSXMLParserDelegate>
{
    // XML Parsing 
    NSData          *dataToParse;
    Banner          *workingEntry;
    NSMutableArray  *workingArray;
    BOOL            waitingForBannerElement;
    NSMutableString *elementString;
}
@property (nonatomic, assign) id <ParseOperationDelegate> delegate;
@property (nonatomic, retain) NSData *dataToParse;
@property (nonatomic, retain) NSMutableArray *workingArray;
@property (nonatomic, retain) Banner *workingEntry;
@property (nonatomic, retain) NSMutableString *elementString;

- (id)initWithData:(NSData *)data delegate:(id <ParseOperationDelegate>)theDelegate;
- (void)parse;
@end

@protocol ParseOperationDelegate
- (void)didFinishParsing:(NSArray *)appList;
- (void)parseErrorOccurred:(NSError *)error;
@end
