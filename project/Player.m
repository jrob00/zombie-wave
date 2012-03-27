//
//  Player.m
//  zombie-wave
//
//  Created by Jason Roberts on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player


+(id) createPlayer:(NSString*)baseImage {

    return [[[self alloc] initWithOurOwnProperties:(NSString*) baseImage] autorelease];
}

-(id) initWithOurOwnProperties:(NSString*) baseImage {

    if ((self = [super init])) {
        
        theBaseImage = baseImage;
        playerSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png", theBaseImage]];
        [self addChild:playerSprite];
        
        playerSprite.position = ccp(0, 0);
        
        [self setUpDefaultAnimation];
        [self schedule:@selector(runPlayerAnimationSequence:) interval: 1.0f/60.0f];
        
    }
    
    return self;
}

-(void) setUpDefaultAnimation {
    currentFrame = 0;
    framesToAnimate = 20;
    theAction = @"default";
}

-(void) setUpFireAnimation {
    currentFrame = 0;
    framesToAnimate = 11;
    theAction = @"fire";
}

-(void) setUpThrowingAnimation {
    currentFrame = 0;
    framesToAnimate = 8;
    theAction = @"throwing";
}

-(void) runPlayerAnimationSequence:(ccTime) delta {
    
    currentFrame++;
    
    if (currentFrame <= framesToAnimate) {
        
        if (currentFrame < 10) {
        
            [playerSprite setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_%@000%i.png", theBaseImage, theAction, currentFrame]] texture] ];
        
        } else if (currentFrame < 100) {

            [playerSprite setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_%@00%i.png", theBaseImage, theAction, currentFrame]] texture] ];
            
        }
    }
    
    if (currentFrame == framesToAnimate) {
    
        [self setUpDefaultAnimation];
    }
    
}

@end
