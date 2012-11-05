//
//  MMViewController.m
//  MovieMatch
//
//  Created by Fernando Gómez on 31/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "MMViewController.h"
#import "FXImageView.h"
#import "RottenTomatoesAPI.h"
#import "Movie.h"
#import "MMDetailedMovieViewController.h"

@interface MMViewController ()
@property (nonatomic) NSMutableArray *items;
@end

@implementation MMViewController
@synthesize carousel;
@synthesize items;

@synthesize toolbarInfo = _toolbarInfo;
@synthesize dragButton = _dragButton;
@synthesize movieScoreLabel = _movieScoreLabel;
@synthesize movieTitleLabel = _movieTitleLabel;
@synthesize percentBar = _percentBar;


- (void)setupView
{
    //    UIView *infoReference = [[[NSBundle mainBundle] loadNibNamed:@"ViewMovieInfo"
    //                                                           owner:self
    //                                                         options:nil] objectAtIndex:0];
    //    _infoView = infoReference;
    [_toolbarInfo setBackgroundImage:[[UIImage imageNamed:@"toolbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13) resizingMode:UIImageResizingModeTile] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [_percentBar setTrackImage:[[UIImage imageNamed:@"progress_track"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4) resizingMode:UIImageResizingModeTile]];
    [_percentBar setProgressImage:[[UIImage imageNamed:@"progress_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4) resizingMode:UIImageResizingModeTile]];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailMovie"]) {
        Movie *movie = [items objectAtIndex:[carousel currentItemIndex]];
        [[segue destinationViewController] setDetailedMovie:movie];
    }
}

#pragma mark -
#pragma mark View lifecycle
- (void)awakeFromNib
{
    //set up data
    NSArray *movies = [RottenTomatoesAPI getMoviesInTheaters];
    NSMutableArray *URLs = [NSMutableArray arrayWithArray:movies];
    self.items = URLs;
    //    [self setupInfoView];
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    carousel.delegate = nil;
    carousel.dataSource = nil;
    
    [carousel release];
    [items release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    //configure carousel
    carousel.type = iCarouselTypeCylinder;
    carousel.viewpointOffset=CGSizeMake(0.0f, -200.0f);
    carousel.contentOffset=CGSizeMake(0.0f, -220.0f);
//    [self setupInfoView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    UIButton *button = (UIButton *)view;
    if (view == nil)
    {
        FXImageView *imageView = [[[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 160.0f, 235.0f)] autorelease];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.asynchronous = YES;
        imageView.reflectionScale = 0.20f;
        imageView.reflectionAlpha = 0.25f;
        imageView.reflectionGap = 10.0f;
        imageView.shadowOffset = CGSizeMake(0.0f, 2.0f);
        imageView.shadowBlur = 8.0f;
        imageView.cornerRadius = 6.0f;
        //        UIImage *image = [UIImage imageNamed:@"page.png"];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0.0f, 0.0f, 190.0f, 266.0f);
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //		[button setBackgroundImage:image forState:UIControlStateNormal];
		button.titleLabel.font = [button.titleLabel.font fontWithSize:50];
		[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        //        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        view = imageView;
        [view addSubview:button];
        
    }
    
    //show placeholder
    ((FXImageView *)view).processedImage = [UIImage imageNamed:@"placeholder.png"];
    
    //set image with URL. FXImageView will then download and process the image
    [(FXImageView *)view setImageWithContentsOfURL:[[items objectAtIndex:index] detailedPoster]];
    return view;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    // Obtener item seleccionado
    Movie *movie = [items objectAtIndex:self.carousel.currentItemIndex];
    
    _movieTitleLabel.text = movie.title;
    _movieScoreLabel.text = [NSString stringWithFormat:@"%d%%", movie.audienceScore];
    [_percentBar setProgress:(movie.audienceScore/100.0f) animated:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    _movieTitleLabel.alpha = 1;
    _movieScoreLabel.alpha = 1;
    _percentBar.alpha = 1;
    [UIView commitAnimations];
}

- (void)carouselDidScroll:(iCarousel *)carousel
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    _movieTitleLabel.alpha = 0;
    _percentBar.alpha = 0;
    _movieScoreLabel.alpha = 0;
    [UIView commitAnimations];
}

- (void)buttonTapped:(UIButton *)sender
{
	//get item index for button

	NSInteger index = [carousel indexOfItemViewOrSubview:sender];
	Movie *movie = [items objectAtIndex:index];
    NSLog(@"Movie tapped: %@", movie.title);
    [self performSegueWithIdentifier:@"detailMovie" sender:carousel];
//    [[[[UIAlertView alloc] initWithTitle:@"Button Tapped"
//                                 message:[NSString stringWithFormat:@"%@ index: %i", movie.title, index]
//                                delegate:nil
//                       cancelButtonTitle:@"OK"
//                       otherButtonTitles:nil] autorelease] show];
    
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
            return 7;
        case iCarouselOptionSpacing:
            return 1.06;
        default:
            return value;
    }
}
- (IBAction)prepareSegue:(id)sender {
    [self performSegueWithIdentifier:@"detailMovie" sender:carousel];
}

- (IBAction)showInfo:(id)sender {
    
}
@end
