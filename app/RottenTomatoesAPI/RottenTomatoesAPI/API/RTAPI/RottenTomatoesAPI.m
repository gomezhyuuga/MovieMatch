//
//  RottenTomatoesAPI.m
//  RottenTomatoesAPI
//
//  Created by Fernando Gómez on 14/11/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "RottenTomatoesAPI.h"
//  API urls
static NSString *kAPIKey = @"5pdfzk2rtxmvfhhwzu7adrrc";
static NSString *kAPIURL = @"http://api.rottentomatoes.com";
static NSString *kJSONMoviesInTheaters = @"/api/public/v1.0/lists/movies/in_theaters.json?apikey=%@";
static NSString *kJSONOpeningMovies = @"/api/public/v1.0/lists/movies/opening.json?apikey=%@";
static NSString *kJSONReviews = @"/api/public/v1.0/movies/770672122/reviews.json?apikey=%@";
static NSString *kJSONSearch = @"/api/public/v1.0/movies.json?apikey=%@&q=%@";
static int defaultLimit = 16;

@interface RottenTomatoesAPI()
@property (nonatomic, retain) id delegator;
@end

@implementation RottenTomatoesAPI
@synthesize connection = _connection;
@synthesize delegator = _delegator;
- (id)initWithDelegate:(id)aDelegate
{
    self = [super init];
    if (self) {
        _delegator = aDelegate;
    }
    return self;
}
# pragma mark - Parser methods
- (NSMutableArray *)dictionaryToMovieObjects:(NSDictionary *)moviesDictionary
{
    NSMutableArray *movies;
    // Si no hay películas devolver array vacío
    movies = [NSMutableArray array];
    if (moviesDictionary.count > 0) {
        // Convertir json a objetos de tipo Movie
        for (id obj in moviesDictionary) {
            // Crear ombjeto a partir de json
            Movie *movie = [[Movie alloc] initWithDictionary:obj];
            [movies addObject:movie];
        }
    }
    return movies;
}
- (NSMutableArray *)dictionaryToReviewObjects:(NSDictionary *)reviewsDictionary
{
    NSMutableArray *reviews;
    // Si no hay reviews devolver array vacío
    reviews = [NSMutableArray array];
    if (reviewsDictionary.count > 0) {
        // Convertir json a objetos tipo Review
        for (id obj in reviewsDictionary) {
            Review *aReview = [[Review alloc] initWithDictionary:obj];
            [reviews addObject:aReview];
        }
    }
    return reviews;
}
#pragma mark - Search movie
- (void)searchMovie:(NSString *)movieTitle
{
    NSString *myurl = [kAPIURL stringByAppendingFormat:kJSONSearch, kAPIKey, movieTitle];
    [self startRequestWithString:myurl];
}
#pragma mark - Getting movie lists
// Iniciar request de películas en carteleras
- (void)moviesInTheatersWithLimit:(int)limit
{
    NSString *myurl = [kAPIURL stringByAppendingFormat:kJSONMoviesInTheaters, kAPIKey];
    myurl = [myurl stringByAppendingFormat:@"&page_limit=%d", limit];
    [self startRequestWithString:myurl];
}

- (void)startRequestWithString:(NSString *)urlAsString
{
    [self startRequestWithURL:[NSURL URLWithString:urlAsString]];
}
- (void)startRequestWithURL:(NSURL *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:_delegator];
}

- (void)moviesInPremieresWithLimit:(int)limit
{
    NSString *myurl = [kAPIURL stringByAppendingFormat:kJSONOpeningMovies, kAPIKey];
    myurl = [myurl stringByAppendingFormat:@"&limit=%d", limit];
    [self startRequestWithString:myurl];
}
- (void)moviesInTheaters
{
    [self moviesInTheatersWithLimit:defaultLimit];
}
- (void)moviesInPremieres
{
    [self moviesInPremieresWithLimit:defaultLimit];
}

#pragma mark Getting reviews
- (void)reviewsForMovie:(Movie *)movie
{
    NSString *reviewsJSON = [movie.links objectForKey:@"reviews"];
    reviewsJSON = [reviewsJSON stringByAppendingFormat:@"?apikey=%@&country=mx", kAPIKey];
    [self startRequestWithString:reviewsJSON];
}

#pragma mark NSURLConnection
@end
