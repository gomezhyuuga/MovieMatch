//
//  MMSearchViewController.m
//  MovieMatch
//
//  Created by Fernando Gómez Herrera on 20/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import "MMSearchViewController.h"
#import "MMDetailViewController.h"
#import "RottenTomatoesAPI.h"
#import "FXImageView.h"
#import "MMMovieTableCell.h"
#import "UIImageView+RottenTomatoesLogo.h"

@interface MMSearchViewController ()
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) RottenTomatoesAPI *api;
@property (nonatomic) BOOL searching;
@property (nonatomic) BOOL letUserSelectRow;
@end

@implementation MMSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.receivedData = [NSMutableData data];
    if (self.api == nil) {
        self.api = [[RottenTomatoesAPI alloc] initWithDelegate:self];
    }
    self.searching = NO;
    self.letUserSelectRow = YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)searchMovie:(NSString *)queryTerm
{
    [self.api searchMovie:queryTerm];
}

#pragma mark - Searchbar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *str = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (str.length > 2) {
        NSLog(@"searching for... %@",str);
        str = [str stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        [self searchMovie:str];
        
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searching = NO;
    self.letUserSelectRow = YES;
    self.tableView.scrollEnabled = YES;
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    self.searching = YES;
    self.letUserSelectRow = NO;
    self.tableView.scrollEnabled = NO;
}

#pragma mark - NSURLConnection protocol
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Petición finalizada! Se recibieron %d bytes de datos",[self.receivedData length]);
    // Parsear datos a JSON
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:nil];
    
    // Crear objetos de películas
    NSArray *movies;
    if (json.count > 0) {
        movies = [self.api dictionaryToMovieObjects:[json objectForKey:@"movies"]];
    }
    if (movies.count == 0) {
        [self alert];
    }
    NSLog(@"Encontradas %d películas", movies.count);
    self.items = [NSMutableArray arrayWithArray:movies];
    
    // Reconfigurar tableView
    self.letUserSelectRow = YES;
    self.searching = NO;
    [self.searchBar setShowsCancelButton:NO animated:YES];
    self.tableView.scrollEnabled = YES;
    [self.tableView reloadData];
    
    // Desaparecer teclado
    [self.searchBar resignFirstResponder];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    [self.receivedData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [self alertError:@"Ha ocurrido un error!" message:[error localizedDescription]];
    [self searchBarCancelButtonClicked:self.searchBar];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cargar y configurar cell
    static NSString *CellIdentifier = @"MovieTableCell";
    MMMovieTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Obtener película
    Movie *movie = [self.items objectAtIndex:indexPath.row];
    
    cell.moviePoster.processedImage = [UIImage imageNamed:@"placeholder"];
    [cell.moviePoster setImageWithContentsOfURL:movie.thumbnailPoster];
    
    cell.movieTitleLabel.text = movie.title;
    cell.yearLabel.text = [NSString stringWithFormat:@"%d", movie.year];
    cell.criticsLabel.text = [NSString stringWithFormat:@"%d%%",movie.criticsScore];
    cell.audienceLabel.text = [NSString stringWithFormat:@"%d%%",movie.audienceScore];
    [cell.criticsLogo setImageForRating:movie.criticsRating forCritics:YES];
    [cell.audienceLogo setImageForRating:movie.audienceRating forCritics:NO];
    
    return cell;
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.letUserSelectRow) {
        return indexPath;
    }
    else {
        [self.searchBar resignFirstResponder];
        [self searchBarCancelButtonClicked:self.searchBar];
        return nil;
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailMovie"] || [segue.identifier isEqualToString:@"DetailMovie2"]) {
        Movie *movie = [self.items objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        [[segue destinationViewController] setDetailedMovie:movie];
    }
}

#pragma mark - Alerts
- (void)alert
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Sin películas!"
                                                      message:@"Tu búsqueda no produjo ningún resultado.."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}
- (void)alertError:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [alert show];
}
@end
