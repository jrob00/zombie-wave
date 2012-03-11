//
//  Bullet.m
//  zombie-wave
//
//  Created by Jason Roberts on 3/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"
#import "Constants.h"

@implementation Bullet

@synthesize bulletSprite;


+(id) createBullet:(NSString*)baseImage {
    
    return [[[self alloc] initWithOurOwnProperties:(NSString*) baseImage] autorelease];
}

-(id) initWithOurOwnProperties:(NSString*) baseImage {
    
    if ((self = [super init])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        screenWidth = size.width;
        screenHeight = size.height;
        
        counter = 20;
        
        theBaseImage = baseImage;
        bulletSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png", theBaseImage]];
        [self addChild:bulletSprite];
        
        bulletSprite.position = ccp(0, 0);
        
        
        [self schedule:@selector(moveBulletUp:)interval:1.0f/60.0f];
    }
    
    return self;
}


-(void) moveBulletUp:(ccTime)delta {
    
    // move our bullet up 20 pixels at a time
    bulletSprite.position = ccp( bulletSprite.position.x, bulletSprite.position.y + (screenHeight / bulletSpeed) );
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    // if our bullet is off the screen then remove it
    if (bulletSprite.position.y > screenSize.height) {
        
        [self unschedule:_cmd];
        [self removeFromParentAndCleanup:YES];
    }
}

-(void) startToMoveBulletDown {
    
    [self unschedule:@selector(moveBulletUp:)];
    
    // move the bullet down 20 so we don't detect 2 collisions with the target
    bulletSprite.position = ccp( bulletSprite.position.x, bulletSprite.position.y - counter );
    
    [self schedule:@selector(moveBulletDown:) interval:1.0f/60.0f];
    
}


-(void) moveBulletDown:(ccTime)delta {
    
    // move our bullet down 20 pixels at a time
    bulletSprite.position = ccp( bulletSprite.position.x, bulletSprite.position.y - counter );
    
    counter--;
    
    // if our bullet is off the screen then remove it
    if (counter == 0) {
        
        [self unschedule:_cmd];
        [self removeFromParentAndCleanup:YES];
    }
}


@end
