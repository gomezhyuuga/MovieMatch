//
//  MMDetailViewController.m
//  MovieMatch
//
//  Created by Fernando Gómez on 18/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import "MMDetailViewController.h"
#import "UIImageView+RottenTomatoesLogo.h"
#import "MMTrailerViewController.h"
#import "MMTomatoMeter.h"
#import <QuartzCore/QuartzCore.h>
#import "FXImageView.h"
#import "MMReviewCell.h"
#import <Social/Social.h>
#import "RottenTomatoesAPI.h"
#import "Actor.h"

@interface MMDetailViewController ()
#pragma mark - Toolbar elements
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *ratingBar;
@property (weak, nonatomic) IBOutlet UILabel *movieScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
#pragma mark - Movie info elements
@property (weak, nonatomic) IBOutlet FXImageView *moviePoster;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;
@property (weak, nonatomic) IBOutlet UILabel *criticsScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *audienceScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *criticsLogo;
@property (weak, nonatomic) IBOutlet UIImageView *audienceLogo;
@property (weak, nonatomic) IBOutlet MMTomatoMeter *tomatoMeter;
@property (weak, nonatomic) IBOutlet UIView *containerViews;
@property (weak, nonatomic) IBOutlet UILabel *criticConsensus;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UITableView *reviewsTableView;
@property (strong, nonatomic) IBOutlet UIScrollView *actorsScrollView;
@property (strong, nonatomic) IBOutlet UITableViewCell *movieYearCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *movieRuntimeCell;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UITableViewCell *movieMPAARatingCell;

@property (nonatomic) NSArray *nibViews;

@property (strong, nonatomic) NSMutableArray *reviews;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) RottenTomatoesAPI *api;

- (IBAction)pageChanged:(id)sender;

- (IBAction)back:(id)sender;
- (void)setDetailedMovie:(Movie *)detailedMovie;
@end

@implementation MMDetailViewController
@synthesize detailedMovie = _detailedMovie;
@synthesize scrollView = _scrollView;

- (void)setDetailedMovie:(Movie *)movie
{
    if (movie != self.detailedMovie) {
        _detailedMovie = movie;
    }
}

- (void)setupView
{
    Movie *movie = [[Movie alloc] init];
    self.containerView.layer.cornerRadius = 4;
    movie.title = @"My movie";
    movie.criticsScore = 90;
    movie.audienceScore = 40;
    movie.audienceRating = @"Upright";
    movie.criticsRating = @"Certified Fresh";
    movie.criticsConsensus = @"Gingerbread jelly beans marzipan cupcake gummi bears marshmallow bonbon tart gummies. Pudding donut gingerbread. Sesame snaps dragée brownie sweet roll cheesecake dessert wypas chocolate biscuit. Toffee bear claw macaroon candy canes cake candy.";
    movie.synopsis = @"A fucking awesome movie";
//    self.detailedMovie = movie;
    
    // Cargar vistas con ScrollView
    self.nibViews = [[NSBundle mainBundle] loadNibNamed:@"MovieInfoView" owner:self options:nil];
    UIScrollView *principalView = [self.nibViews objectAtIndex:0];   // Vista principal
    UIView *criticsView = [self.nibViews objectAtIndex:1];   // Vista de reviews
    UIView *detailedInfoView = [self.nibViews objectAtIndex:2];   // Vista de información de película
    
    // Asignar la posición en x de las vistas
    criticsView.frame = CGRectMake(principalView.frame.size.width, 0, criticsView.frame.size.width, criticsView.frame.size.height);
    detailedInfoView.frame = CGRectMake(principalView.frame.size.width * 2, 0, criticsView.frame.size.width, criticsView.frame.size.height);
    // Agregar vistas
    [principalView addSubview:criticsView];
    [principalView addSubview:detailedInfoView];
    principalView.contentSize = CGSizeMake(principalView.frame.size.width * 3, principalView.frame.size.height);
    principalView.delegate = self;
    [self.containerViews addSubview:principalView];
    
    // Configurar background
    principalView.layer.cornerRadius = 4;
    self.containerViews.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.containerViews.layer.shadowOffset = CGSizeMake(0, 0);
    self.containerViews.layer.shadowOpacity = 0.7;
    self.containerViews.layer.shadowRadius = 4;
    [self.tomatoMeter setTrackImage:[[UIImage imageNamed:@"Tomatometer_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    // Establecer info de película...
    self.movieTitleLabel.text = self.detailedMovie.title;
    self.movieScoreLabel.text = [NSString stringWithFormat:@"%d%%",self.detailedMovie.criticsScore];
    self.synopsis.text = self.detailedMovie.synopsis;
    // ...scores y logos
    [self.ratingBar setProgress:self.detailedMovie.criticsScore/100.0f];
    [self.tomatoMeter setProgress:self.detailedMovie.criticsScore/100.0f];
    self.audienceScoreLabel.text = [NSString stringWithFormat:@"%d%%", self.detailedMovie.audienceScore];
    self.criticsScoreLabel.text = [NSString stringWithFormat:@"%d%%", self.detailedMovie.criticsScore];
    [self.criticsLogo setImageForRating:self.detailedMovie.criticsRating forCritics:YES];
    [self.audienceLogo setImageForRating:self.detailedMovie.audienceRating forCritics:NO];
    // ..poster
    self.moviePoster.contentMode = UIViewContentModeScaleToFill;
    self.moviePoster.asynchronous = YES;
    self.moviePoster.reflectionScale = 0.15f;
    self.moviePoster.reflectionAlpha = 0.25f;
    self.moviePoster.reflectionGap = 6;
    self.moviePoster.shadowOffset = CGSizeMake(0, 2);
    self.moviePoster.shadowColor = [UIColor blackColor];
    self.moviePoster.shadowBlur = 4;
    self.moviePoster.cornerRadius = 3;
    self.moviePoster.processedImage = [UIImage imageNamed:@"placeholder"];
    [self.moviePoster setImageWithContentsOfURL:self.detailedMovie.detailedPoster];
    
    // Críticas
    self.criticConsensus.text = [NSString stringWithFormat:@"\"%@\"", self.detailedMovie.criticsConsensus];
    self.reviewsTableView.layer.cornerRadius = 4;
    // Cargar reviews
    if (self.api == nil) {
        self.api = [[RottenTomatoesAPI alloc] initWithDelegate:self];
        self.receivedData = [NSMutableData data];
    }
    [self.api reviewsForMovie:self.detailedMovie];
    
    // Actores
    int width = 243;
    int height = 31;
    self.actorsScrollView.delegate = self;
    self.actorsScrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.actorsScrollView.layer.cornerRadius = 4;
    NSLog(@"%f", self.actorsScrollView.contentSize.height);
    int i = 0;
    // Lista de personajes interpretados por actor
    
    for (Actor *obj in self.detailedMovie.actors) {
        NSString *characters = [obj.characters componentsJoinedByString:@", "];
//        UITableViewCell *actorCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 31 * i, width, height)];
        UITableViewCell *actorCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"actorCell"];
        actorCell.backgroundColor = [UIColor clearColor];
        UILabel *actorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width-10, 15)];
        UILabel *charactersLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, width-10, 15)];
        actorNameLabel.font = [UIFont boldSystemFontOfSize:12];
        actorNameLabel.textColor = [UIColor blackColor];
        actorNameLabel.backgroundColor = [UIColor clearColor];
        charactersLabel.font = [UIFont systemFontOfSize:12];
        charactersLabel.textColor = [UIColor blackColor];
        charactersLabel.backgroundColor = [UIColor clearColor];
        actorNameLabel.text = obj.name;
        charactersLabel.text = characters;
//        actorCell.textLabel.text = obj.name;
        [actorCell addSubview:actorNameLabel];
        [actorCell addSubview:charactersLabel];
//        [[[self.actorsScrollView subviews] objectAtIndex:1]addSubview:actorCell];
        [self.actorsScrollView addSubview:actorCell];
        actorNameLabel.frame = CGRectMake(10, 0, width-10, 15);
        charactersLabel.frame = CGRectMake(10, 15, width-10, 15);
        actorCell.frame = CGRectMake(0, (31 * i) + 4, width, height);
        i = i + 1;
    }
    self.actorsScrollView.contentSize = CGSizeMake(width, height * self.detailedMovie.actors.count);
    self.movieYearCell.detailTextLabel.text = [NSString stringWithFormat:@"%d", self.detailedMovie.year];
    self.movieMPAARatingCell.detailTextLabel.text = self.detailedMovie.mpaa_rating;
    self.movieRuntimeCell.detailTextLabel.text = [NSString stringWithFormat:@"%d minutos", self.detailedMovie.runtime];
}
#pragma mark - Segues
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)showTrailer:(id)sender {
    MMTrailerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TrailerController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    NSString *query = [self.detailedMovie.title stringByAppendingString:@" trailer"];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://www.youtube.com/results?search_query=%@&oq=%@", query, query];
    NSLog(@"%@", url);
    [vc setTrailerURL:url];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([[segue identifier] isEqualToString:@"ShowTrailer"]) {
//        [[segue destinationViewController] setTrailerURL:@"http://www.rottentomatoes.com/m/toy_story_3/trailers/11028566"];
//    }
}
#pragma mark - ScrollView and PageControl handlers
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)newScrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    // Obtener qué página es en base a la posición en que está el scrollView
    int page = self.scrollView.contentOffset.x / pageWidth;
    [self changePage:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)newScrollView
{
	[self scrollViewDidEndScrollingAnimation:newScrollView];
}
- (void)changePage:(int)indexPage
{
    self.pageControl.currentPage = indexPage;
}
- (IBAction)pageChanged:(id)sender {
    CGPoint newPosition = CGPointMake(self.scrollView.frame.size.width * [sender currentPage], 0);
    [self.scrollView setContentOffset:newPosition animated:YES];
}

#pragma NSURLConnection protocol
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Petición finalizada! Se recibieron %d bytes de datos",[self.receivedData length]);
    // Parsear datos a JSON
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:nil];
    
    // Crear objetos de reviews
    NSArray *reviews = [self.api dictionaryToReviewObjects:[json objectForKey:@"reviews"]];
    NSLog(@"Cargados %d reviews", reviews.count);
    self.reviews = [NSMutableArray arrayWithArray:reviews];
    
    // Recargar tableData
//    NSLog(@"%@",[[self.reviews objectAtIndex:0] quote]);
    [self.reviewsTableView reloadData];
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
}
#pragma mark - TableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reviews.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 240, 56)];
    Review *aReview = [self.reviews objectAtIndex:indexPath.row];
    // Texto de la crítica
    UILabel *labelQuote = [[UILabel alloc] initWithFrame:CGRectMake(38, 2, 193, 41)];
    labelQuote.backgroundColor = [UIColor clearColor];
    labelQuote.numberOfLines = 4;
    labelQuote.font = [UIFont systemFontOfSize:8.0];
    labelQuote.textColor = [UIColor grayColor];
    labelQuote.shadowColor = [UIColor whiteColor];
    labelQuote.shadowOffset = CGSizeMake(0, 1);
    labelQuote.text = aReview.quote;
    // Autor de crítica y fecha
    UILabel *labelAuthor = [[UILabel alloc] initWithFrame:CGRectMake(38, 43, 193, 12)];
    labelAuthor.backgroundColor = [UIColor clearColor];
    labelAuthor.numberOfLines = 1;
    labelAuthor.textAlignment = NSTextAlignmentRight;
    labelAuthor.font = [UIFont italicSystemFontOfSize:8];
    labelAuthor.textColor = [UIColor grayColor];
    labelAuthor.shadowColor = [UIColor whiteColor];
    labelAuthor.shadowOffset = CGSizeMake(0, 1);
    labelAuthor.text = [NSString stringWithFormat:@"- %@, %@, %@", aReview.critic, aReview.publication, aReview.date];
    // Imagen
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 20, 20)];
    [imageView setImageForRating:aReview.freshness forCritics:YES];
    // Agregar views
    cell.backgroundColor = [UIColor clearColor];
    [cell addSubview:labelQuote];
    [cell addSubview:labelAuthor];
    [cell addSubview:imageView];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 56.0f;
}

#pragma mark - Social functions
- (IBAction)shareMovie:(UIButton*)sender {
    // Configurar el sheet de compartir
    NSString *title = self.detailedMovie.title;
    NSString *message = [NSString stringWithFormat:@"Las críticas de la película %@ se ven genial en #MovieMatch!", title];
    NSString *service;
    if (sender.tag == -1) {
        service = SLServiceTypeFacebook;
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *tweetPostVC = [SLComposeViewController composeViewControllerForServiceType:service];
            [tweetPostVC setInitialText:message];
            [self presentViewController:tweetPostVC animated:YES completion:nil];
        }
    } else if (sender.tag == -2) {
        service = SLServiceTypeTwitter;
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *tweetPostVC = [SLComposeViewController composeViewControllerForServiceType:service];
            [tweetPostVC setInitialText:message];
            [self presentViewController:tweetPostVC animated:YES completion:nil];
        }
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Definir qué orientaciones permite
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end