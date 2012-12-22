//
//  RottenTomatoesAPI.h
//  MovieMatch
//
//  Created by Fernando Gómez on 26/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RottenTomatoesAPI : NSObject
+ (NSArray *)getMoviesInTheaters;
+ (NSArray *)getMoviesInTheatersWithLimit:(int)limit;
+ (NSArray *)getOpeningMoviesWithLimit:(int) limit;
+ (NSArray *)getOpeningMovies;
+ (NSArray *)getMoviesInTheatersAndOpening;
+ (NSArray *)getMoviesInTheatersAndOpeningWithLimit:(int) limit;
@end