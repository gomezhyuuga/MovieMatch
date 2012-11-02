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

@interface MMViewController ()
@property (nonatomic) NSMutableArray *items;
@end

@implementation MMViewController
@synthesize carousel;
@synthesize items;
@synthesize titleLabel;
@synthesize ratingLabel;
@synthesize percentBar;
- (void)awakeFromNib
{
    //set up data
    NSArray *movies = [RottenTomatoesAPI getMoviesInTheaters];
    NSMutableArray *URLs = [NSMutableArray arrayWithArray:movies];
    self.items = URLs;
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

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //configure carousel
    carousel.type = iCarouselTypeCylinder;
    carousel.viewpointOffset=CGSizeMake(0.0f, -200.0f);
    carousel.contentOffset=CGSizeMake(0.0f, -235.0f);
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
        imageView.reflectionScale = 0.15f;
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
    //    [(FXImageView *)view setImageWithContentsOfURL:[items objectAtIndex:index]];
    [(FXImageView *)view setImageWithContentsOfURL:[[items objectAtIndex:index] detailedPoster]];
    return view;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    NSLog(@"Cambiado a otra peli!");
    //    titleLabel.alpha = 1;
    // Obtener item seleccionado
    Movie *movie = [items objectAtIndex:self.carousel.currentItemIndex];
    
    titleLabel.text = movie.title;
    ratingLabel.text = [NSString stringWithFormat:@"%d%%", movie.audienceScore];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.titleLabel.alpha = 1;
    ratingLabel.alpha = 1;
    percentBar.alpha = 1;
    [percentBar setProgress:(movie.audienceScore/100) animated:YES];
    [UIView commitAnimations];
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.titleLabel.alpha = 0;
    self.percentBar.alpha = 0;
    self.ratingLabel.alpha = 0;
    [UIView commitAnimations];
}

- (void)buttonTapped:(UIButton *)sender
{
	//get item index for button
	NSInteger index = [carousel indexOfItemViewOrSubview:sender];
	
    [[[[UIAlertView alloc] initWithTitle:@"Button Tapped"
                                 message:[NSString stringWithFormat:@"You tapped button number %i", index]
                                delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] autorelease] show];
    
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
@end
