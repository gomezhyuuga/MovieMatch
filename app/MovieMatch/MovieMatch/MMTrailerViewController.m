//
//  MMTrailerViewController.m
//  MovieMatch
//
//  Created by Fernando Gómez on 18/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import "MMTrailerViewController.h"

@interface MMTrailerViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSURLRequest *trailerRequest;
- (IBAction)backButton:(UIBarButtonItem *)sender;
@end

@implementation MMTrailerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setTrailerURL:(NSString *)url
{
    self.trailerRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.webView loadRequest:self.trailerRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
