//
//  PlayingCard.h
//  Matchismo
//
//  Created by Dominic Wong on 21/3/14.
//  Copyright (c) 2014 Dominic Wong. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
