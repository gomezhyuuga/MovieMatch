//
//  MMDetailViewController.m
//  MovieMatch
//
//  Created by Fernando Gómez on 28/10/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "MMDetailViewController.h"
#import "MMUtils.h"
#import "UIImage+ImageBlur.h"

@interface MMDetailViewController ()
- (void)setDetailedMovie:(Movie *)detailedMovie;
@end

@implementation MMDetailViewController
@synthesize detailedMovie = _detailedMovie;
@synthesize movieTitle = _movieTitle;
@synthesize bgImage = _bgImage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self configureView];
    }
    return self;
}

-(void)configureView
{
    _movieTitle.text = _detailedMovie.title;
    NSData* imageData = [MMUtils getDataFromURL:_detailedMovie.detailedPoster];
    _bgImage.image = [UIImage imageWithData:imageData];
    _bgImage.image = [[_bgImage.image imageWithGaussianBlur] imageWithGaussianBlur];
}

-(void)setDetailedMovie:(Movie *)detailedMovie
{
    _detailedMovie = detailedMovie;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
