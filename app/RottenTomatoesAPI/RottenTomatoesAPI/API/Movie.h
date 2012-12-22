//
//  Movie.h
//  MovieMatch
//
//  Created by Fernando Gómez on 26/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject
@property (nonatomic) NSString *movieId;
@property (nonatomic) NSString *title;
@property (nonatomic) int year;
@property (nonatomic) NSString *mpaa_rating;
@property (nonatomic) int runtime;
@property (nonatomic) NSString *synopsis;
@property (nonatomic) NSURL *thumbnailPoster, *detailedPoster, *originalPoster;
@property (nonatomic) int audienceScore, criticsScore;;
@property (nonatomic) NSString *audienceRating, *criticsRating;
@property (nonatomic) NSString * criticsConsensus;
@property (nonatomic) NSString* logoForCritics;
@property (nonatomic) NSString* logoForAudience;

+ (NSArray *) listOfMovies:(NSArray *) arrayOfMovies;
@end
