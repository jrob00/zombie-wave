//
//  Enemy.h
//  zombie-wave
//
//  Created by Jason Roberts on 3/18/12.
//  Copyright 2012 Clover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Enemy : CCNode {
    
    NSString *theBaseImage; // theBaseImage = baseImage
    NSString* theAction;
    
    CCSprite *enemySprite;
    
    int screenWidth;
    int screenHeight;
    
    int currentFrame;
    int framesToAnimate;
    
    float downwardSpeed;
    
    BOOL enemyNeedsShootingTwice;
    BOOL enemyShotOnceAlready;
}

@property (readonly, nonatomic) CCSprite * enemySprite;
@property (readonly, nonatomic) BOOL enemyNeedsShootingTwice;
@property (readonly, nonatomic) BOOL enemyShotOnceAlready;


+(id) createEnemy:(NSString*)baseImage;
-(id) initWithOurOwnProperties:(NSString*) baseImage;

-(void) setUpDefaultAnimation;
-(void) makeEnemyRed;

@end
