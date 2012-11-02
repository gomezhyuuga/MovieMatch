//
//  MMUIToolbarMovie.m
//  MovieMatch
//
//  Created by Fernando Gómez on 01/11/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "MMUIToolbarMovie.h"

@implementation MMUIToolbarMovie

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //// General Declarations
    [self setFrame:CGRectMake(0, 0, 320, 74)];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* infobarColor = [UIColor colorWithRed: 0.506 green: 0.624 blue: 0.271 alpha: 1];
    UIColor* infobarColor2 = [UIColor colorWithRed: 0.176 green: 0.38 blue: 0.106 alpha: 1];
    CGFloat infobarColor2HSBA[4];
    [infobarColor2 getHue: &infobarColor2HSBA[0] saturation: &infobarColor2HSBA[1] brightness: &infobarColor2HSBA[2] alpha: &infobarColor2HSBA[3]];
    
    UIColor* color = [UIColor colorWithHue: infobarColor2HSBA[0] saturation: infobarColor2HSBA[1] brightness: 0.3 alpha: infobarColor2HSBA[3]];
    UIColor* shadowColor2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.42];
    
    //// Gradient Declarations
    NSArray* infobarColors = [NSArray arrayWithObjects:
                              (id)infobarColor.CGColor,
                              (id)infobarColor2.CGColor, nil];
    CGFloat infobarLocations[] = {0, 1};
    CGGradientRef infobar = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)infobarColors, infobarLocations);
    
    //// Shadow Declarations
    UIColor* shadow = shadowColor2;
    CGSize shadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat shadowBlurRadius = 1;
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.5, 0.5, 320, 74) cornerRadius: 6];
    CGContextSaveGState(context);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, infobar, CGPointMake(160.5, 0.5), CGPointMake(160.5, 74.5), 0);
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [color setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(infobar);
    CGColorSpaceRelease(colorSpace);
}

@end
