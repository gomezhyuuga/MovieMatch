//
//  Movie.m
//  MovieMatch
//
//  Created by Fernando Gómez on 26/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "Movie.h"

static NSString *RTFreshLogo = @"RottenTomatoesLogo_fresh";
static NSString *RTRottenLogo = @"RottenTomatoesLogo_rotten";
static NSString *RTSpilledLogo = @"RottenTomatoesLogo_spilled";
static NSString *RTCertifiedLogo = @"RottenTomatoesLogo_certified";
static NSString *RTPopcornLogo = @"RottenTomatoesLogo_popcorn";
static NSString *RTPlusLogo = @"RottenTomatoesLogo_plus";

@interface Movie()
@end

@implementation Movie
@synthesize logoForCritics = _logoForCritics;
@synthesize logoForAudience = _logoForAudience;
@synthesize movieId = _movieId;
@synthesize title = _title;
@synthesize synopsis = _synopsis;
@synthesize year = _year;
@synthesize detailedPoster = _detailedPoster, originalPoster = _originalPoster, thumbnailPoster = _thumbnailPoster;
@synthesize mpaa_rating = _mpaa_rating;
@synthesize runtime = _runtime;
@synthesize audienceScore = _audienceScore, audienceRating = _audienceRating;
@synthesize criticsScore = _criticsScore;
@synthesize criticsRating = _criticsRating;
@synthesize criticsConsensus = _criticsConsensus;
- (id) init
{
    self = [super init];
    
    if (self) {
    }
    return self;
}

/*
 Devuelve array de objetos Movie a partir
*/
+ (NSArray *)listOfMovies:(NSArray *)arrayOfMovies
{
    NSMutableArray* movies = [[NSMutableArray alloc] init];
    for (id obj in arrayOfMovies) {
        Movie* movie = [self initFromDictionary:obj];
        [movies addObject:movie];
    }
    return movies;
}

+ (Movie *)initFromDictionary:(NSDictionary *) dictionary
{
    Movie* movie = nil;
    if ([dictionary count] > 0) {
        movie = [[Movie alloc] init];
        // Obtener atributos de la película y asignar
        movie.title = [dictionary objectForKey:@"title"];
        movie.year = [[dictionary objectForKey:@"year"] integerValue];
        movie.movieId = [dictionary objectForKey:@"id"];
        movie.mpaa_rating = [dictionary objectForKey:@"mpaa_rating"];
        movie.runtime = [[dictionary objectForKey:@"runtime"] integerValue];
        movie.synopsis = [dictionary objectForKey:@"synopsis"];
        // Posters
        NSDictionary* posters = [dictionary objectForKey:@"posters"];
        movie.thumbnailPoster = [NSURL URLWithString: [posters objectForKey:@"thumbnail"]];
        movie.detailedPoster = [NSURL URLWithString: [posters objectForKey:@"detailed"]];
        movie.originalPoster = [NSURL URLWithString: [posters objectForKey:@"original"]];
        // Ratings
        NSDictionary *ratings = [dictionary objectForKey:@"ratings"];
        NSString *rating = nil;
        int score = [[ratings objectForKey:@"audience_score"] integerValue];
        rating = [ratings objectForKey:@"audience_rating"];
        // Audience rating en openning movies no está establecido
        if (rating != nil) {
            movie.audienceRating = rating;
        }
        if (score < 0 ) {
            movie.audienceScore = 0;
        } else {
            movie.audienceScore = score;
        }
        rating = [ratings objectForKey:@"critics_rating"];
        score = [[ratings objectForKey:@"critics_score"] integerValue];
        if (rating != nil) {
            movie.criticsRating = rating;
        }
        if (score < 0 ) {
            movie.criticsScore = 0;
        } else {
            movie.criticsScore = score;
        }
        // Critics
        if ([dictionary objectForKey:@"critics_consensus"] != nil) {
            movie.criticsConsensus = [dictionary objectForKey:@"critics_consensus"];
        } else {
            movie.criticsConsensus = @"Sin crítica";
        }
        // Logos
        NSString *criticsRating = movie.criticsRating;
        if ([criticsRating isEqualToString:@"Certified Fresh"]) {
            movie.logoForCritics = RTCertifiedLogo;
        } else if ([criticsRating isEqualToString:@"Rotten"]) {
            movie.logoForCritics = RTRottenLogo;
        } else if ([criticsRating isEqualToString:@"Fresh"]) {
            movie.logoForCritics = RTFreshLogo;
        } else {
            movie.logoForCritics = RTRottenLogo;
        }
        
        
        // ... and logo for audience
        NSString *audienceRating = movie.audienceRating;
        if ([audienceRating isEqualToString:@"Upright"]) {
            movie.logoForAudience = RTPopcornLogo;
        } else if ([audienceRating isEqualToString:@"Spilled"]) {
            movie.logoForAudience = RTSpilledLogo;
        } else {
            movie.logoForAudience = RTPlusLogo;
        }
    }
    return movie;
}

-(NSString *) description
{
    NSString* desc = [NSString stringWithFormat:
                      @"# %@\
                      \n- id: %@\
                      \n- year: %d\
                      \n- runtime: %d\
                      \n- synopsis: %@\
                      \n* posters:\
                      \n\t - thumbnail: %@\
                      \n\t - detailed: %@\
                      \n\t - original: %@",
                      _title, _movieId, _year, _runtime, _synopsis, _thumbnailPoster, _detailedPoster, _originalPoster];
    return desc;
}
@end
