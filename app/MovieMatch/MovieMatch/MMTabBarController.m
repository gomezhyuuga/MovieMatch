//
//  MMTabBarController.m
//  MovieMatch
//
//  Created by Fernando Gómez on 16/02/13.
//  Copyright (c) 2013 Appsolut. All rights reserved.
//

#import "MMTabBarController.h"

@interface MMTabBarController ()

@end

@implementation MMTabBarController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)shouldAutorotate
{
    NSLog(@"Orientation: %d", [[UIDevice currentDevice] orientation]);
    return YES;
}
@end
