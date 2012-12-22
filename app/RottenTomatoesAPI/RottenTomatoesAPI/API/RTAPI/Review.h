//
//  Review.h
//  RottenTomatoesAPI
//
//  Created by Fernando Gómez on 19/11/12.
//  Copyright (c) 2012 hbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@interface Review : NSObject
@property (nonatomic) NSString *critic;
@property (nonatomic) NSString *date;
@property (nonatomic) NSString *freshness;
@property (nonatomic) NSString *publication;
@property (nonatomic) NSString *quote;
@property (nonatomic) NSDictionary *links;
@property (nonatomic, weak) Movie *movie;

- (id)initWithDictionary:(NSDictionary *) dictionary;
@end
