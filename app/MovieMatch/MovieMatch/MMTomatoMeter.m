//
//  MMTomatoMeter.m
//  MovieMatch
//
//  Created by Fernando Gómez on 18/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import "MMTomatoMeter.h"

@implementation MMTomatoMeter

- (void)changeProgressTrackWithProgress:(float)progress
{
    if (progress >= 0.75) {
        [self setProgressImage:[[UIImage imageNamed:@"Tomatometer_red"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    } else {
        [self setProgressImage:[[UIImage imageNamed:@"Tomatometer_green"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    }
}
- (void)setProgress:(float)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:animated];
    [self changeProgressTrackWithProgress:progress];
}

- (void)setProgress:(float)progress
{
    [super setProgress:progress];
    [self changeProgressTrackWithProgress:progress];
}

@end
