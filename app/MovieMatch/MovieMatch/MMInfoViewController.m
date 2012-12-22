//
//  MMInfoViewController.m
//  MovieMatch
//
//  Created by Fernando Gómez on 18/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import "MMInfoViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MMInfoViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MMInfoViewController

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
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.shadowOpacity = 0.7;
    self.bgView.layer.shadowRadius = 4;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
