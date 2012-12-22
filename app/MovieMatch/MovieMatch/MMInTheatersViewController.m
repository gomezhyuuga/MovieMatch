//
//  MMInTheatersViewController.m
//  MovieMatch
//
//  Created by Fernando Gómez on 18/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import "MMInTheatersViewController.h"
#import "MMDetailViewController.h"
#import "RottenTomatoesAPI.h"
#import "Movie.h"
#import "FXImageView.h"

@interface MMInTheatersViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *ratingBar;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *movieScoreLabel;


@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) RottenTomatoesAPI *api;
@end

@implementation MMInTheatersViewController
@synthesize items = _items;
@synthesize carousel = _carousel;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Configurar carousel
    self.carousel.type = iCarouselTypeCylinder;
    self.carousel.viewpointOffset = CGSizeMake(0.0f, -230.0f);
    self.carousel.contentOffset = CGSizeMake(0.0f, -245.0f);
    // Obtener lista de películas
    [self obtenerPeliculas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.carousel = nil;
    self.items = nil;
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
// Aparecer/desaparecer información de película
- (void)fadeInfoWithAlpha:(float)alpha andDuration:(float)duration
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    self.movieTitleLabel.alpha = alpha;
    self.movieScoreLabel.alpha = alpha;
    self.ratingBar.alpha = alpha;
    [UIView commitAnimations];
}

#pragma mark - iCarousel methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        FXImageView *imageView = [[[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 160.0f, 250.0f)] autorelease];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.asynchronous = YES;
        imageView.reflectionScale = 0.20f;
        imageView.reflectionAlpha = 0.25f;
        imageView.reflectionGap = 10.0f;
        imageView.shadowOffset = CGSizeMake(0.0f, 2.0f);
        imageView.shadowBlur = 8.0f;
        imageView.cornerRadius = 6.0f;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; 
		button.frame = imageView.frame;
		[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        view = imageView;
        [view addSubview:button];
    }
    Movie *movie = [self.items objectAtIndex:index];
    ((FXImageView *)view).processedImage = [UIImage imageNamed:@"placeholder.png"];
    
    if (movie != nil) {
        [(FXImageView *)view setImageWithContentsOfURL:movie.detailedPoster];
    }
    
    return view;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    // Obtener item seleccionado
    Movie *movie = [self.items objectAtIndex:self.carousel.currentItemIndex];
    // Actualizar con información
    self.movieTitleLabel.text = movie.title;
    self.movieScoreLabel.text = [NSString stringWithFormat:@"%d%%", movie.criticsScore];
    // Cambiar porcentaje de la barra
    [self.ratingBar setProgress:(movie.criticsScore/100.0f) animated:YES];
    
    [self fadeInfoWithAlpha:1 andDuration:0.25];
}
- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    [self fadeInfoWithAlpha:0 andDuration:0.2];
}
- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel
{
    [self fadeInfoWithAlpha:0 andDuration:0.2];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionFadeMin:
            return -0.2;
        case iCarouselOptionFadeMax:
            return 0.2;
        case iCarouselOptionFadeRange:
            return 10.0;
        case iCarouselOptionSpacing:
            return 1.1;
        default:
            return value;
    }
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

#pragma NSURLConnection protocol
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.loadingView.alpha != 1) {
        [self toggleLoading:YES];
    }
    NSLog(@"Petición finalizada! Se recibieron %d bytes de datos",[self.receivedData length]);
    // Parsear datos a JSON
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:nil];
    
    // Crear objetos de películas
    NSArray *movies = [self.api dictionaryToMovieObjects:[json objectForKey:@"movies"]];
    if (movies.count == 0) {
        [self alert];
    }
    NSLog(@"Cargadas %d películas", movies.count);
    self.items = [NSMutableArray arrayWithArray:movies];
    
    // Recargar carousel
    [self.carousel reloadData];
    [self.carousel reloadInputViews];
    
    // Ocultar indicador de carga
    [self toggleLoading:NO];
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
- (void)buttonTapped:(UIButton *)sender
{
	// Obtener index del item pulsado y pelicula
    [self performSegueWithIdentifier:@"DetailMovie" sender:self.carousel];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DetailMovie"]) {
        Movie *movie = [self.items objectAtIndex:[self.carousel currentItemIndex]];
        [[segue destinationViewController] setDetailedMovie:movie];
    }
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
