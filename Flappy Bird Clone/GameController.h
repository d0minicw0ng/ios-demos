//
//  GameController.h
//  Flappy Bird Clone
//
//  Created by Dominic Wong on 8/4/14.
//  Copyright (c) 2014 Dominic Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

int BirdFlight;
int RandomTopTunnelPosition;
int RandomBottomTunnelPosition;

@interface GameController : UIViewController
{
    IBOutlet UIImageView *Bird;
    IBOutlet UIButton *StartGame;
    IBOutlet UIImageView *TunnelTop;
    IBOutlet UIImageView *TunnelBottom;
    IBOutlet UIImageView *Top;
    IBOutlet UIImageView *Bottom;
    
    NSTimer *BirdMovement;
    NSTimer *TunnelMovement;
}

-(IBAction)StartGame:(id)sender;
-(void)BirdMoving;
-(void)TunnelMoving;
-(void)PlaceTunnels;

@end
