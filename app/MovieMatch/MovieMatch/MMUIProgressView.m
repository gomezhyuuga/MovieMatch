//
//  MMUIProgressView.m
//  MovieMatch
//
//  Created by Fernando Gómez on 18/11/12.
//  Copyright (c) 2012 Appsolut. All rights reserved.
//

#import "MMUIProgressView.h"

@implementation MMUIProgressView

- (void)changeProgressTrackWithProgress:(float)progress
{
    if (progress > 0.5 && progress < 0.75) {
        [self setProgressImage:[[UIImage imageNamed:@"progress_orange"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)]];
    } else if (progress >= 0.75) {
        [self setProgressImage:[[UIImage imageNamed:@"progress_green"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)]];
    } else {
        [self setProgressImage:[[UIImage imageNamed:@"progress_red"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)]];
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
