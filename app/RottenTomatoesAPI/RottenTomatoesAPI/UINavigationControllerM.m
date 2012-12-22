//
//  UINavigationController.m
//  RottenTomatoesAPI
//
//  Created by Fernando Gómez Herrera on 16/11/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "UINavigationControllerM.h"

@interface UINavigationControllerM ()

@end

@implementation UINavigationControllerM

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
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
//    [[UINavigationBar appearance] ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
