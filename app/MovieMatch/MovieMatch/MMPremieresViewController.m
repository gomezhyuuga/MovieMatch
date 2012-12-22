//
//  MMPremieresViewController.m
//  MovieMatch
//
//  Created by Fernando Gómez on 19/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import "MMPremieresViewController.h"
#import "MMDetailViewController.h"
#import "RottenTomatoesAPI.h"
#import "Movie.h"
#import "MMMovieCollectionCell.h"
#import "UIImageView+RottenTomatoesLogo.h"

@interface MMPremieresViewController ()
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) RottenTomatoesAPI *api;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@end

@implementation MMPremieresViewController
- (UICollectionViewCell*)collectionView:(UICollectionView*)cv cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    // Configurar cell
    MMMovieCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell"forIndexPath:indexPath];
    cell.moviePoster.asynchronous = YES;
    cell.moviePoster.backgroundColor = [UIColor clearColor];
    cell.moviePoster.shadowColor = [UIColor blackColor];
    cell.moviePoster.shadowOffset = CGSizeMake(0, 1);
    cell.moviePoster.shadowBlur = 3;
    cell.moviePoster.cornerRadius = 2;
    cell.moviePoster.processedImage = [UIImage imageNamed:@"placeholder"];
    // Asignar atributos de la película
    Movie *movie = [_items objectAtIndex:indexPath.row];
    [cell.moviePoster setImageWithContentsOfURL:movie.detailedPoster];
    cell.criticsScoreLabel.text = [NSString stringWithFormat:@"%d%%", movie.criticsScore];
    [cell.criticsLogo setImageForRating:movie.criticsRating forCritics:YES];
    cell.audienceScoreLabel.text = [NSString stringWithFormat:@"%d%%", movie.audienceScore];
    [cell.audienceLogo setImageForRating:movie.audienceRating forCritics:NO];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (void)obtenerPeliculas
{
    if (!self.receivedData) {
        self.receivedData = [NSMutableData data];
    }
    if (!self.api) {
        self.api = [[RottenTomatoesAPI alloc] initWithDelegate:self];
    }
    // Comenzar petición al servidor
    [self.api moviesInTheaters];
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MovieSegue"]) {
        NSIndexPath *index = [self.collectionView.indexPathsForSelectedItems objectAtIndex:0];
        Movie *movie = [_items objectAtIndex:index.row];
        [[segue destinationViewController] setDetailedMovie:movie];
    }
}

#pragma NSURLConnection protocol
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    if (self.loadingView.alpha != 1) {
//        [self toggleLoading:YES];
//    }
    NSLog(@"Petición finalizada! Se recibieron %d bytes de datos",[self.receivedData length]);
    // Parsear datos a JSON
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:nil];
    
    // Crear objetos de películas
    NSArray *movies = [self.api dictionaryToMovieObjects:[json objectForKey:@"movies"]];
    NSLog(@"Cargadas %d películas", movies.count);
    if (movies.count == 0) {
        [self alert];
    }
    self.items = [NSMutableArray arrayWithArray:movies];
    
    // Recargar vista
    [self.collectionView reloadData];
    
    // Ocultar indicador de carga
//    [self toggleLoading:NO];
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
}

- (void)toggleLoading:(BOOL)on
{
    float alpha;
    if (!on) {
        alpha = 0;
    } else {
        alpha = 1;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.loadingView.alpha = alpha;
    [UIView commitAnimations];
}

#pragma mark - View methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self obtenerPeliculas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Alerts
- (void)alert
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Sin películas!"
                                                      message:@"Posiblemente tu conexión a internet no esté funcionando..."
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
