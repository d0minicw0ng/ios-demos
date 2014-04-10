//
//  GameController.m
//  Flappy Bird Clone
//
//  Created by Dominic Wong on 8/4/14.
//  Copyright (c) 2014 Dominic Wong. All rights reserved.
//

#import "GameController.h"

@interface GameController ()

@end

@implementation GameController

-(IBAction)StartGame:(id)sender
{
    StartGame.hidden = YES;
    TunnelTop.hidden = NO;
    TunnelBottom.hidden = NO;
    Bird.hidden = NO;

    
    BirdMovement = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(BirdMoving)
                                                   userInfo:nil repeats:YES];
    
    TunnelMovement = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(TunnelMoving) userInfo:nil repeats:YES];
    
    [self PlaceTunnels];
}

-(void)addScore
{
    ScoreNumber = ScoreNumber + 1;
    ScoreLabel.text = [NSString stringWithFormat:@"%i", ScoreNumber];
}

-(void)GameOver
{
    if (ScoreNumber > HighScoreNumber) {
        [[NSUserDefaults standardUserDefaults] setInteger:ScoreNumber forKey:@"HighScoreSaved"];
    }
    
    [TunnelMovement invalidate];
    [BirdMovement invalidate];
    
    StartGame.hidden = NO;
    TunnelTop.hidden = YES;
    TunnelBottom.hidden = YES;
    Bird.hidden = YES;
}

-(void)PlaceTunnels
{
    RandomTopTunnelPosition = arc4random() %350;
    RandomTopTunnelPosition = RandomTopTunnelPosition - 228;
    RandomBottomTunnelPosition = RandomTopTunnelPosition + 700;
    
    TunnelTop.center = CGPointMake(340, RandomTopTunnelPosition);
    TunnelBottom.center = CGPointMake(340, RandomBottomTunnelPosition);
}

-(void)TunnelMoving
{
    TunnelTop.center = CGPointMake(TunnelTop.center.x - 1, TunnelTop.center.y);
    TunnelBottom.center = CGPointMake(TunnelBottom.center.x - 1, TunnelBottom.center.y);

    if (TunnelTop.center.x < -28) {
        [self PlaceTunnels];
    }
    
    if (TunnelTop.center.x == 30) {
        [self addScore];
    }
    
    for (UIImageView* obstacle in @[TunnelTop, TunnelBottom, Top, Bottom]) {
        if (CGRectIntersectsRect(Bird.frame, obstacle.frame)) {
            [self GameOver];
        }
    }
    //if (CGRectIntersectsRect(Bird.frame, TunnelTop.frame)) {
    //    [self GameOver];
    //}
    
    //if (CGRectIntersectsRect(Bird.frame, TunnelBottom.frame)) {
    //    [self GameOver];
    //}
    
    //if (CGRectIntersectsRect(Bird.frame, Top.frame)) {
    //    [self GameOver];
    //}
    
    //if (CGRectIntersectsRect(Bird.frame, Bottom.frame)) {
    //    [self GameOver];
    //}
}

-(void)BirdMoving
{
    Bird.center = CGPointMake(Bird.center.x, Bird.center.y - BirdFlight);
    
    BirdFlight = BirdFlight - 5;
    
    if (BirdFlight < -15) {
        BirdFlight = -15;
    }
    
    if (BirdFlight > 0) {
        Bird.image = [UIImage imageNamed:@"bird.png"];
    } else {
        Bird.image = [UIImage imageNamed:@"bird_down.png"];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    BirdFlight = 15;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    TunnelTop.hidden = YES;
    TunnelBottom.hidden = YES;
    
    ScoreNumber = 0;
    HighScoreNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
