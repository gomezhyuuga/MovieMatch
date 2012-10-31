//
//  RottenTomatoesAPI.m
//  MovieMatch
//
//  Created by Fernando Gómez on 26/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "RottenTomatoesAPI.h"
#import "MMUtils.h"
#import "Movie.h"
static NSString *kApiURL = @"http://api.rottentomatoes.com";
static NSString *kApiKey = @"5pdfzk2rtxmvfhhwzu7adrrc";
static NSString *kMoviesInTheatersFeed = @"/api/public/v1.0/lists/movies/in_theaters.json?apikey=";

@interface RottenTomatoesAPI()
@end
@implementation RottenTomatoesAPI

+ (NSArray *)getMoviesInTheaters
{
    NSString *requestURL = [[[kApiURL stringByAppendingString:kMoviesInTheatersFeed] stringByAppendingString:kApiKey] stringByAppendingString:@"&page_limit=2"];
    // Hacer petición
    NSData *response = [MMUtils getDataFromURLAsString:requestURL];
    // Obtener feed de películas en carteleras y serializar el JSON
    NSDictionary* in_theaters_feed = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    NSLog(@"movies isa: %@", [[in_theaters_feed valueForKey:@"movies"] class]);
    NSLog(@"a movie isa: %@", [[[in_theaters_feed valueForKey:@"movies"] objectAtIndex:0] class]);
    NSArray* movies = [Movie listOfMovies:[in_theaters_feed objectForKey:@"movies"]];
    for (Movie *movie in movies) {
        NSLog(@"%@", movie);
    }
    return movies;
}
@end