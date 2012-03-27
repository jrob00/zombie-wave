//
//  Enemy.m
//  zombie-wave
//
//  Created by Jason Roberts on 3/18/12.
//  Copyright 2012 Clover. All rights reserved.
//

#import "Enemy.h"
#import "GameData.h"
#import "MainGame.h"

@implementation Enemy

@synthesize enemySprite, enemyNeedsShootingTwice, enemyShotOnceAlready;


+(id) createEnemy:(NSString*)baseImage {
    
    return [[[self alloc] initWithOurOwnProperties:(NSString*) baseImage] autorelease];
}

-(id) initWithOurOwnProperties:(NSString*) baseImage {
    
    if ((self = [super init])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        screenWidth = size.width;
        screenHeight = size.height;
        
        downwardSpeed = .002 * screenHeight;
        
        if ([[GameData sharedData] returnWave] > 1) {
            
            enemyNeedsShootingTwice = YES;
            
        } else {
            
            enemyNeedsShootingTwice = NO;
        }
        
        enemyShotOnceAlready = NO;
        
        theBaseImage = baseImage;
        enemySprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png", theBaseImage]];
        [self addChild:enemySprite];
        
        enemySprite.position = ccp(0, 0);
        
        [self setUpDefaultAnimation];
        [self schedule:@selector(runEnemyAnimationSequence:) interval: 1.0f/60.0f];
        
    }
    
    return self;
}

-(void) setUpDefaultAnimation {
    
    currentFrame = 0;
    framesToAnimate = 31;
    theAction = @"crawl";
    
}

-(void) makeEnemyGoLower {
    
    // pause the enemy if we paused our game
    if ( [[MainGame sharedMainGame] isGamePaused] == NO ) {
        
        self.position = ccp(self.position.x, self.position.y - downwardSpeed);
        
    }
}

// this gets triggered when shot once
-(void) makeEnemyRed {
    
    enemySprite.color = ccRED;
    enemyShotOnceAlready = YES;
    
    // optionally we could make the enemy faster
    //downwardSpeed = downwardSpeed * 2;
    
}

-(void) runEnemyAnimationSequence:(ccTime) delta {
    
    [self makeEnemyGoLower];
    
    currentFrame++;
    
    if (currentFrame <= framesToAnimate) {
        
        if (currentFrame < 10) {
            
            [enemySprite setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_%@000%i.png", theBaseImage, theAction, currentFrame]] texture] ];
            
        } else if (currentFrame < 100) {
            
            [enemySprite setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_%@00%i.png", theBaseImage, theAction, currentFrame]] texture] ];
            
        }
    }
    
    if (currentFrame == framesToAnimate) {
        
        [self setUpDefaultAnimation];
    }
    
}


@end
