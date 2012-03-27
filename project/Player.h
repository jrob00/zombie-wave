//
//  Player.h
//  zombie-wave
//
//  Created by Jason Roberts on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCNode {
    
    NSString *theBaseImage; // theBaseImage = baseImage
    NSString* theAction;
    CCSprite *playerSprite;
    
    int currentFrame;
    int framesToAnimate;
}

+(id) createPlayer:(NSString*)baseImage;
-(id) initWithOurOwnProperties:(NSString*) baseImage;
-(void) setUpDefaultAnimation;
-(void) setUpFireAnimation;
-(void) setUpThrowingAnimation;

@end