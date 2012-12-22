//
//  Review.m
//  RottenTomatoesAPI
//
//  Created by Fernando Gómez on 19/11/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import "Review.h"

@implementation Review
@synthesize critic = _critic;
@synthesize date = _date;
@synthesize quote = _quote;
@synthesize freshness = _freshness;
@synthesize publication = _publication;
@synthesize links = _links;
@synthesize movie = _movie;

- (id)initWithDictionary:(NSDictionary *) dictionary
{
    self = [super init];
    if (dictionary != nil) {
        _critic = [dictionary objectForKey:@"critic"];
        _date = [dictionary objectForKey:@"date"];
        _quote = [dictionary objectForKey:@"quote"];
        _publication = [dictionary objectForKey:@"publication"];
        _freshness = [dictionary objectForKey:@"freshness"];
        _links = [dictionary objectForKey:@"links"];
    }
    return self;
}

- (id)init
{
    return [self initWithDictionary:nil];
}

@end
