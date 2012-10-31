//
//  MMUtils.m
//  MovieMatch
//
//  Created by Fernando Gómez on 28/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "MMUtils.h"

@implementation MMUtils
+ (NSData *)getDataFromURL:(NSURL *)url
{
    // Prepare URL request to download data
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // Perform request
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return response;
}

+ (NSData *)getDataFromURLAsString:(NSString *)urlAsString
{
    NSURL *url = [NSURL URLWithString:urlAsString];
    return [self getDataFromURL:url];
}
@end
