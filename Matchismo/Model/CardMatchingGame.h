//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Dominic Wong on 23/3/14.
//  Copyright (c) 2014 Dominic Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) BOOL threeCardMatch;
@end
