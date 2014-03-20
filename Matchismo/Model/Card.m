//
//  Card.m
//  Matchismo
//
//  Created by Dominic Wong on 21/3/14.
//  Copyright (c) 2014 Dominic Wong. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards){
        if ([card.contents isEqualToString:self.contents]){
            score = 1;
        }
    }
    
    return score;
}

@end
