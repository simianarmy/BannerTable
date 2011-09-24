
//
//  FileHelpers.m
//  BannerView
//
//  Created by Marc Mauger on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileHelpers.h"

NSString *pathInDocumentDirectory(NSString *fileName)
{
    NSArray *documentDirectories = 
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:fileName];
}

NSString *pathInCachesDirectory(NSString *fileName)
{
    NSArray *cacheDirectories = 
        NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *cacheDirectory = [cacheDirectories objectAtIndex:0];
    
    return [cacheDirectory stringByAppendingPathComponent:fileName];
}

