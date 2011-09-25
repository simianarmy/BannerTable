//
//  StatsPoster.m
//  BannerView
//
//  Created by Marc Mauger on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StatsPoster.h"
#import "UserStats.h"

@implementation StatsPoster
@synthesize delegate, postConnection, request;

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.postConnection = nil;
        self.request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod: @"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    }
    
    return self;
}

// Posts stats data to the url asynchronously.
// Delegate methods will handle response.
- (void)postStats:(UserStats *)userStats delegate:(id<PostOperationDelegate>)theDelegate
{
    self.delegate = theDelegate;
    NSString *postData = [userStats queryString];
    NSLog(@"Posting user stats %@...", postData);
    
    NSData *myRequestData = [NSData dataWithBytes: [postData UTF8String] length: [postData length]];
    [request setHTTPBody:myRequestData];
    
    postConnection = [[NSURLConnection alloc] initWithRequest:request
                                                     delegate:self
                                             startImmediately:YES];    
}

- (void)dealloc
{
    [postConnection release];
    [request release];
    
    [super dealloc];
}

#pragma mark - 
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // TODO: Check response for success/failure
    NSLog(@"Stats post received...resetting stats");
    [self.delegate didFinishPosting];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Stats post failed!");
    [self.delegate postErrorOccurred:error];
}

@end
