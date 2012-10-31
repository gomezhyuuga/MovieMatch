//
//  MMViewController.m
//  MovieMatch
//
//  Created by Fernando Gómez on 26/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "MMTableViewController.h"
#import "RottenTomatoesAPI.h"
#import "Movie.h"
#import "MMUtils.h"
#import "MMDetailViewController.h"

@implementation MMViewController
{
    NSArray *tableData;
}
@synthesize movieTitle;
@synthesize poster;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray* movies = [RottenTomatoesAPI getMoviesInTheaters];
    tableData = movies;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    Movie* movie = [tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = movie.title;
    
    NSData* img = [MMUtils getDataFromURL:movie.thumbnailPoster];
    cell.imageView.image = [UIImage imageWithData:img];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Movie *movie = [tableData objectAtIndex:indexPath.row];
        NSLog(@"MOVIE: %@", movie.title);
        [[segue destinationViewController] setDetailedMovie:movie];
    }
}
@end
