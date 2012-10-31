//
//  Movie.m
//  MovieMatch
//
//  Created by Fernando Gómez on 26/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "Movie.h"

@interface Movie()

@end

@implementation Movie
@synthesize movieId = _movieId;
@synthesize title = _title;
@synthesize synopsis = _synopsis;
@synthesize year = _year;
@synthesize detailedPoster = _detailedPoster, originalPoster = _originalPoster, thumbnailPoster = _thumbnailPoster;
@synthesize mpaa_rating = _mpaa_rating;
@synthesize runtime = _runtime;
//- (id) init
//{
//    self = [super init];
//    
//    if (self) {
//    }
//    return self;
//}

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
//    return [movies copy];
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
