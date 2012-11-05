//
//  MMDetailedMovieViewController.m
//  MovieMatch
//
//  Created by Fernando Gómez on 04/11/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "MMDetailedMovieViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MMDetailedMovieViewController ()
- (void)setDetailedMovie:(Movie *)movie;
@end

@implementation MMDetailedMovieViewController

@synthesize toolbarInfo = _toolbarInfo;
@synthesize percentBar = _percentBar;
@synthesize detailedMovie = _detailedMovie;
@synthesize movieTitleLabel = _movieTitleLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize detailBG = _detailBG;

- (void)setupView
{
    [_toolbarInfo setBackgroundImage:[[UIImage imageNamed:@"toolbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13) resizingMode:UIImageResizingModeTile] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [_percentBar setTrackImage:[[UIImage imageNamed:@"progress_track"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4) resizingMode:UIImageResizingModeTile]];
    [_percentBar setProgressImage:[[UIImage imageNamed:@"progress_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4) resizingMode:UIImageResizingModeTile]];
    
    _movieTitleLabel.text = _detailedMovie.title;
    _scoreLabel.text = [NSString stringWithFormat:@"%d%%", _detailedMovie.audienceScore];
    _percentBar.progress = _detailedMovie.audienceScore/100.0f;
    _detailBG.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _detailBG.layer.borderWidth = 1.0f;
    _detailBG.layer.cornerRadius = 4.0f;
    _detailBG.layer.shadowColor = [[UIColor whiteColor] CGColor];
    _detailBG.layer.shadowOffset = CGSizeMake(0, 1);
    _detailBG.layer.shadowOpacity = 0.5f;
    _detailBG.layer.shadowRadius = 0.0f;
}

- (void)setDetailedMovie:(Movie *)movie
{
    _detailedMovie = movie;
}

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
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
