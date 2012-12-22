//
//  ViewController.m
//  RottenTomatoesAPI
//
//  Created by Fernando Gómez on 14/11/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "ViewController.h"
#import "RottenTomatoesAPI.h"
@interface ViewController ()
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) RottenTomatoesAPI *api;
@property (nonatomic, retain) NSMutableArray *dataSource;
@property int cual;
@end

@implementation ViewController
@synthesize receivedData = _receivedData;
@synthesize api = _api;
#pragma mark ViewController lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cual = 2;
    _receivedData = [NSMutableData data];
	// Do any additional setup after loading the view, typically from a nib.
    _api = [[RottenTomatoesAPI alloc] initWithDelegate:self];
    if (self.cual == 1) {
        [_api moviesInTheaters];
//        [_api moviesInPremieres];
    } else if (self.cual == 0) {
        Movie *myMovie = [[Movie alloc] init];
        NSMutableDictionary *links = [NSMutableDictionary dictionary];
        [links setObject:@"http://api.rottentomatoes.com/api/public/v1.0/movies/770687943/reviews.json" forKey:@"reviews"];
        myMovie.links = links;
        [self.api reviewsForMovie:myMovie];
    } else if (self.cual == 2) {
        NSString *searchTerm = @"Story";
        [self.api searchMovie:searchTerm];
    }
}

#pragma NSURLConnection protocol
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[_receivedData length]);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_receivedData options:0 error:nil];
    if (self.cual == 1) {
        NSArray *movies = [_api dictionaryToMovieObjects:[json objectForKey:@"movies"]];
        NSLog(@"loaded %d movies", movies.count);
        Movie *aMovie = [movies objectAtIndex:0];
        NSLog(@"*** %@", aMovie.title);
    } else if (self.cual == 0) {
        NSArray *reviews = [_api dictionaryToReviewObjects:[json objectForKey:@"reviews"]];
        NSLog(@"loaded %d reviews", reviews.count);
        Review *aReview = [reviews objectAtIndex:0];
        NSLog(@"*** %@", aReview.quote);
    } else if (self.cual == 2) {
        NSArray *movies = [_api dictionaryToMovieObjects:[json objectForKey:@"movies"]];
        NSLog(@"loaded %d movies", movies.count);
        Movie *aMovie = [movies objectAtIndex:0];
        NSLog(@"*** %@", aMovie.title);
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
