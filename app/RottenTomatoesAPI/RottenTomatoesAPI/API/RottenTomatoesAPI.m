//
//  RottenTomatoesAPI.m
//  MovieMatch
//
//  Created by Fernando Gómez on 26/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "RottenTomatoesAPI.h"
#import "Movie.h"

static NSString *kApiURL = @"http://api.rottentomatoes.com";
static NSString *kApiKey = @"5pdfzk2rtxmvfhhwzu7adrrc";
static NSString *kMoviesInTheatersFeed = @"/api/public/v1.0/lists/movies/in_theaters.json?apikey=";
static NSString *kOpeningMoviesFeed = @"/api/public/v1.0/lists/movies/opening.json?apikey=";
static int defaultLimit = 16;

@interface RottenTomatoesAPI()
@end
@implementation RottenTomatoesAPI

+ (NSArray *)getMoviesInTheatersAndOpeningWithLimit:(int) limit
{
    NSArray *inTheaters = [self getMoviesInTheatersWithLimit:limit];
    NSArray *opening = [self getOpeningMoviesWithLimit:limit];
    NSArray *bothMovies = [[NSArray arrayWithArray:inTheaters] arrayByAddingObjectsFromArray:opening];
    return bothMovies;
}
+ (NSArray *)getMoviesInTheatersAndOpening
{
    return [self getMoviesInTheatersAndOpeningWithLimit:defaultLimit];
}

+ (NSArray *)getMoviesInTheaters
{
    return [self getMoviesInTheatersWithLimit:defaultLimit];
}
+ (NSArray *)getMoviesInTheatersWithLimit:(int) limit
{
    return [self getMoviesFromFeed:kMoviesInTheatersFeed andLimit:[NSString stringWithFormat:@"&page_limit=%d", limit]];
}

+ (NSArray *)getOpeningMoviesWithLimit:(int) limit
{
    return [self getMoviesFromFeed:kOpeningMoviesFeed andLimit:[NSString stringWithFormat:@"&limit=%d", limit]];
}

+ (NSArray *)getOpeningMovies
{
    return [self getMoviesFromFeed:kOpeningMoviesFeed andLimit:[NSString stringWithFormat:@"&limit=%d", defaultLimit]];
}

+ (NSArray *)getMoviesFromFeed:(NSString *) feed andLimit:(NSString*) limit
{
    NSString *requestURL = [[[kApiURL stringByAppendingString:feed] stringByAppendingString:kApiKey] stringByAppendingString:limit];
    // Hacer petición
    NSData *response = [self getDataFromURLAsString:requestURL];
    // Obtener feed de películas en carteleras y serializar el JSON
    NSArray *movies;
    if (response != nil) {
        NSDictionary *movies_feed = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
        movies = [Movie listOfMovies:[movies_feed objectForKey:@"movies"]];
    } else {
        movies = [NSArray array];
    }
    //    NSLog(@"movies isa: %@", [[movies_feed valueForKey:@"movies"] class]);
    //    NSLog(@"a movie isa: %@", [[[movies_feed valueForKey:@"movies"] objectAtIndex:0] class]);
    //    for (Movie *movie in movies) {
    //        NSLog(@"%@", movie);
    //    }
    return movies;
}

// Hacer una petición http y obtener datos
+ (NSData *)getDataFromURL:(NSURL *)url
{
    // Preparar request con URL
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // Hacer request
    NSError *myError;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&myError];
    if (myError != nil) {
//        NSLog(@"%@", myError);
        response = [NSData data];
    }
    return response;
}
+ (NSData *)getDataFromURLAsString:(NSString *)urlAsString
{
    NSURL *url = [NSURL URLWithString:urlAsString];
    return [self getDataFromURL:url];
}
@end