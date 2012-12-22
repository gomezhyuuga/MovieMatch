//
//  Movie.m
//  RottenTomatoesAPI
//
//  Created by Fernando Gómez on 14/11/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "Movie.h"
#import "Actor.h"
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
@synthesize detailedPoster = _detailedPoster, profilePoster = _profilePoster,
    originalPoster = _originalPoster, thumbnailPoster = _thumbnailPoster;
@synthesize mpaa_rating = _mpaa_rating;
@synthesize runtime = _runtime;
@synthesize audienceScore = _audienceScore, audienceRating = _audienceRating;
@synthesize criticsScore = _criticsScore;
@synthesize criticsRating = _criticsRating;
@synthesize criticsConsensus = _criticsConsensus;
@synthesize actors = _actors;
@synthesize links = _links;

#pragma mark - Initalizers
- (id)initWithDictionary:(NSDictionary *) dictionary
{
    self = [super init];
    if (self && dictionary.count > 0) {
        // Obtener atributos de la película y asignar
        self.title = [dictionary objectForKey:@"title"];
        self.year = [[dictionary objectForKey:@"year"] integerValue];
        self.movieId = [dictionary objectForKey:@"id"];
        self.mpaa_rating = [dictionary objectForKey:@"mpaa_rating"];
        self.runtime = [[dictionary objectForKey:@"runtime"] integerValue];
        self.synopsis = [dictionary objectForKey:@"synopsis"];
        // Posters
        NSDictionary* posters = [dictionary objectForKey:@"posters"];
        self.thumbnailPoster = [NSURL URLWithString: [posters objectForKey:@"thumbnail"]];
        self.profilePoster = [NSURL URLWithString: [posters objectForKey:@"profile"]];
        self.detailedPoster = [NSURL URLWithString: [posters objectForKey:@"detailed"]];
        self.originalPoster = [NSURL URLWithString: [posters objectForKey:@"original"]];
        // Ratings
        NSDictionary *ratings = [dictionary objectForKey:@"ratings"];
        NSString *rating = nil;
        int score = [[ratings objectForKey:@"audience_score"] integerValue];
        rating = [ratings objectForKey:@"audience_rating"];
        // Audience rating en openning movies no está establecido
        if (rating != nil) {
            self.audienceRating = rating;
        }
        if (score < 0 ) {
            self.audienceScore = 0;
        } else {
            self.audienceScore = score;
        }
        rating = [ratings objectForKey:@"critics_rating"];
        score = [[ratings objectForKey:@"critics_score"] integerValue];
        if (rating != nil) {
            self.criticsRating = rating;
        }
        if (score < 0 ) {
            self.criticsScore = 0;
        } else {
            self.criticsScore = score;
        }
        // Critics
        if ([dictionary objectForKey:@"critics_consensus"] != nil) {
            self.criticsConsensus = [dictionary objectForKey:@"critics_consensus"];
        } else {
            self.criticsConsensus = @"Sin crítica";
        }
        // Logos
        NSString *criticsRating = self.criticsRating;
        if ([criticsRating isEqualToString:@"Certified Fresh"]) {
            self.logoForCritics = RTCertifiedLogo;
        } else if ([criticsRating isEqualToString:@"Rotten"]) {
            self.logoForCritics = RTRottenLogo;
        } else if ([criticsRating isEqualToString:@"Fresh"]) {
            self.logoForCritics = RTFreshLogo;
        } else {
            self.logoForCritics = RTRottenLogo;
        }
        
        // ... and logo for audience
        NSString *audienceRating = self.audienceRating;
        if ([audienceRating isEqualToString:@"Upright"]) {
            self.logoForAudience = RTPopcornLogo;
        } else if ([audienceRating isEqualToString:@"Spilled"]) {
            self.logoForAudience = RTSpilledLogo;
        } else {
            self.logoForAudience = RTPlusLogo;
        }
        
        // Actores
        NSMutableArray *mArray = [NSMutableArray array];
        for (id obj in [dictionary objectForKey:@"abridged_cast"]) {
            Actor *anActor = [[Actor alloc] initWithDictionary:obj];
            [mArray addObject:anActor];
        }
        self.actors = mArray;
        
        // Links
        self.links = [dictionary objectForKey:@"links"];
    }
    return self;
}
- (id)init
{
    return [self initWithDictionary:nil];
}

- (NSString *) description
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

