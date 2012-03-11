//
//  Bullet.h
//  zombie-wave
//
//  Created by Jason Roberts on 3/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Bullet : CCNode {
    
    NSString *theBaseImage; // theBaseImage = baseImage
    CCSprite *bulletSprite;
    
    int counter;
    int screenWidth;
    int screenHeight;
}

@property (readonly, nonatomic) CCSprite* bulletSprite;

+(id) createBullet:(NSString*)baseImage;
-(id) initWithOurOwnProperties:(NSString*) baseImage;

-(void) startToMoveBulletDown;


@end
