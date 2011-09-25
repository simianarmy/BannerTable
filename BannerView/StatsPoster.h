//
//  StatsPoster.h
//  BannerView
//
//  Created by Marc Mauger on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserStats;

@protocol PostOperationDelegate;

@interface StatsPoster : NSObject
{
    NSURLConnection *postConnection;
    NSMutableURLRequest *request;
}
@property (nonatomic, assign) id <PostOperationDelegate> delegate;
@property (nonatomic, retain) NSURLConnection *postConnection;
@property (nonatomic, retain) NSMutableURLRequest *request;

- (id)initWithURL:(NSURL *)url;
- (void)postStats:(UserStats *)stats delegate:(id <PostOperationDelegate>)theDelegate;
@end

@protocol PostOperationDelegate
- (void)didFinishPosting;
- (void)postErrorOccurred:(NSError *)error;
@end