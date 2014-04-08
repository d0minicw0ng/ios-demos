//
//  GameController.h
//  Flappy Bird Clone
//
//  Created by Dominic Wong on 8/4/14.
//  Copyright (c) 2014 Dominic Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

int BirdFlight;

@interface GameController : UIViewController
{
    IBOutlet UIImageView *Bird;
    IBOutlet UIButton *StartGame;
    
    NSTimer *BirdMovement;
}

-(IBAction)StartGame:(id)sender;
-(void)BirdMoving;
@end
