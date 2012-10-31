//
//  Movie.h
//  MovieMatch
//
//  Created by Fernando Gómez on 26/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject
@property (nonatomic) NSString* movieId;
@property (nonatomic) NSString* title;
@property (nonatomic) int year;
@property (nonatomic) NSString* mpaa_rating;
@property (nonatomic) int runtime;
@property (nonatomic) NSString* synopsis;
@property (nonatomic) NSURL* thumbnailPoster;
@property (nonatomic) NSURL* detailedPoster;
@property (nonatomic) NSURL* originalPoster;

+ (NSArray *) listOfMovies:(NSArray *) arrayOfMovies;
@end
