//
//  Card.h
//  Matchismo
//
//  Created by Dominic Wong on 21/3/14.
//  Copyright (c) 2014 Dominic Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
