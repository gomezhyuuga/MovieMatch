//
//  RottenTomatoesAPI.h
//  RottenTomatoesAPI
//
//  Created by Fernando Gómez on 14/11/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import "Review.h"

@interface RottenTomatoesAPI : NSObject <NSURLConnectionDataDelegate>
@property (nonatomic, retain) NSURLConnection *connection;
- (id)initWithDelegate:(id)aDelegate;

#pragma mark - Getting movie lists
- (void)moviesInTheaters;
- (void)moviesInTheatersWithLimit:(int)limit;
- (void)moviesInPremieres;
- (void)moviesInPremieresWithLimit:(int)limit;
#pragma mark - Getting reviews
- (void)reviewsForMovie:(Movie *)movie;
#pragma mark - Search
- (void)searchMovie:(NSString *)movieTitle;
#pragma mark - JSON to Objects
- (NSArray *)dictionaryToMovieObjects:(NSDictionary *)moviesDictionary;
- (NSMutableArray *)dictionaryToReviewObjects:(NSDictionary *)reviewsDictionary;
@end
