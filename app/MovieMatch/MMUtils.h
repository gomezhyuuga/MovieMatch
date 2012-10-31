//
//  MMUtils.h
//  MovieMatch
//
//  Created by Fernando Gómez on 28/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMUtils : NSObject
+ (NSData *)getDataFromURL:(NSURL *)url;
+ (NSData *)getDataFromURLAsString:(NSString *)urlAsString;
@end
