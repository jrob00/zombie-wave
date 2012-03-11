//
//  MainGame.h
//  zombie-wave
//
//  Created by Jason Roberts on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "Bullet.h"
#import "SimpleAudioEngine.h"


@interface MainGame : CCLayer {
    
    Player *thePlayer;
    CCSprite *theTarget;
    CCSprite *thePoints;
    
    CCLabelBMFont *scoreLabel;
    
    int screenWidth;
    int screenHeight;
    int yLocationOfPlayer;
    int score;
    
    signed char moveVar;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(BOOL) checkCollisionWithBullseye: (CGPoint) bulletPointToCheck;
-(BOOL) checkCollisionWithEntireTarget: (CGPoint) bulletPointToCheck;
-(void) addToScore:(int) amountToAdd;

@end
