//
//  RottenTomatoesAPI.m
//  MovieMatch
//
//  Created by Fernando Gómez on 26/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "RottenTomatoesAPI.h"
//#import "MMUtils.h"
#import "Movie.h"

static NSString *kApiURL = @"http://api.rottentomatoes.com";
static NSString *kApiKey = @"5pdfzk2rtxmvfhhwzu7adrrc";
static NSString *kMoviesInTheatersFeed = @"/api/public/v1.0/lists/movies/in_theaters.json?apikey=";
static int defaultLimit = 16;

@interface RottenTomatoesAPI()
@end
@implementation RottenTomatoesAPI

+ (NSArray *)getMoviesInTheaters
{
    return [self getMoviesInTheatersWithLimit:defaultLimit];
}

+ (NSArray *)getMoviesInTheatersWithLimit:(int) limit
{
    NSString *requestURL = [[[kApiURL stringByAppendingString:kMoviesInTheatersFeed] stringByAppendingString:kApiKey] stringByAppendingFormat:@"&page_limit=%d", limit];
    // Hacer petición
    NSData *response = [self getDataFromURLAsString:requestURL];
    // Obtener feed de películas en carteleras y serializar el JSON
    NSDictionary* in_theaters_feed = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    NSArray* movies = [Movie listOfMovies:[in_theaters_feed objectForKey:@"movies"]];
    //    NSLog(@"movies isa: %@", [[in_theaters_feed valueForKey:@"movies"] class]);
    //    NSLog(@"a movie isa: %@", [[[in_theaters_feed valueForKey:@"movies"] objectAtIndex:0] class]);
    //    for (Movie *movie in movies) {
    //        NSLog(@"%@", movie);
    //    }
    return movies;
}

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