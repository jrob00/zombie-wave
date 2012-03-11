//
//  MainGame.m
//  zombie-wave
//
//  Created by Jason Roberts on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainGame.h"


@implementation MainGame

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainGame *layer = [MainGame node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        //[[SimpleAudioEngine sharedEngine] playEffect:@"gunshot.caf"];
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"musicloop.mp3" loop:YES];
        
        self.isTouchEnabled = YES;

        CGSize size = [[CCDirector sharedDirector] winSize];
        screenWidth = size.width;
        screenHeight = size.height;
        
        moveVar = 3;
        scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"hooge2.fnt"];
        scoreLabel.position = ccp(screenWidth * .9, 20);
        [self addChild:scoreLabel];
        
        
        CCSprite *TempSprite = [CCSprite spriteWithFile:@"dude.png"];
        yLocationOfPlayer = TempSprite.contentSize.height / 2;
        
        thePlayer = [Player createPlayer:@"dude"];
        [self addChild:thePlayer z:10];
        thePlayer.position = ccp(screenWidth / 2, yLocationOfPlayer);
        
        theTarget = [CCSprite spriteWithFile:@"target.png"];
        [self addChild:theTarget z:1];
        theTarget.position = ccp(screenWidth / 2, screenHeight - (theTarget.contentSize.height / 2) );
        
        CCSprite *theBackground = [CCSprite spriteWithFile:@"background.png"];
        [self addChild:theBackground z:-10];
        theBackground.position = ccp(screenWidth / 2, screenHeight / 2 );

        
        
        [self schedule:@selector(automaticFire:) interval:2.0f];
        [self schedule:@selector(mainGameLoop:)  interval:1.0f/60.0f];
        
	}
	return self;
}


-(void) automaticFire:(ccTime) delta {
    
    CCLOG(@"fire");
    
    [thePlayer setUpFireAnimation];
    
    Bullet *theBullet = [Bullet createBullet:@"round"];
    [self addChild:theBullet z:5];
    theBullet.position = ccp(thePlayer.position.x, thePlayer.contentSize.height);
    

    [[SimpleAudioEngine sharedEngine] playEffect:@"gunshot.caf"];
    [[SimpleAudioEngine sharedEngine] playEffect:@"shell_drop.caf"];
}


// pretty much controls everything
-(void) mainGameLoop:(ccTime) delta {
    
    // positioning & moving the target
    
    theTarget.position = ccp(theTarget.position.x + moveVar, theTarget.position.y);
    
    if (theTarget.position.x > screenWidth) {
        
        moveVar = moveVar * -1;
        
    } else if (theTarget.position.x <= 0) {
        
        moveVar = moveVar * -1;
    }
    
    
    // collision detection for the bullet and target
    
    // cycle through every child and find the bullets
    
    for (Bullet *someBullet in self.children) {
        
        if ( [someBullet isKindOfClass:[Bullet class]] ) {
            
            // someBullet is the Bullet
            // someBullet.bulletSprite is the actual bulletSprite
            
            CGPoint bulletPoint = ccp(someBullet.position.x, someBullet.bulletSprite.position.y);
            
            if ( [self checkCollisionWithBullseye:bulletPoint] == YES ) {
                
                CCLOG(@"collided with bullseye");
                
                // add to the score
                [self addToScore:10];
                
                // show the points
                thePoints = [CCSprite spriteWithFile:@"points.png"];
                [self addChild:thePoints z:20];
                thePoints.position = ccp(someBullet.position.x, screenHeight - thePoints.contentSize.height);
                
                [self schedule:@selector(getRidOfPointsSign:) interval:0.8];
                
                [self removeChild:someBullet cleanup:YES];
                
            } else if ( [self checkCollisionWithEntireTarget:bulletPoint] == YES ) {
                
                CCLOG(@"collided with target, not bullseye");
                
                // make the bullet richocet
                [someBullet startToMoveBulletDown];
                
                // add to the score
                [self addToScore:1];
            }
        }
    }
    
}

-(void) addToScore:(int) amountToAdd {

    score = score + amountToAdd;
    
    NSString* scoreString = [NSString stringWithFormat:@"%i", score];
    [scoreLabel setString:scoreString];
    
}

-(void) getRidOfPointsSign:(ccTime) delta {
    
    [self removeChild:thePoints cleanup:NO];
    [self unschedule:_cmd];
}

-(BOOL) checkCollisionWithBullseye: (CGPoint) bulletPointToCheck {
    
    float maxCollisionDistance = 20;
    
    CGPoint checkPoint = ccp(theTarget.position.x, theTarget.position.y);
    
    // compare the distance between the two CGPoints
    float distanceBetween = ccpDistance(bulletPointToCheck, checkPoint);
    
    if (distanceBetween < maxCollisionDistance) {
        return YES;
    }
    
    return NO;
}

-(BOOL) checkCollisionWithEntireTarget: (CGPoint) bulletPointToCheck {
    
    float maxCollisionDistance = theTarget.contentSize.width / 2;
    
    CGPoint checkPoint = ccp(theTarget.position.x, theTarget.position.y);
    
    
    if (bulletPointToCheck.x > ( checkPoint.x - maxCollisionDistance) &&
        bulletPointToCheck.x < ( checkPoint.x + maxCollisionDistance) &&
        bulletPointToCheck.y >= checkPoint.y
    ) {
        return YES;
    }
    
    return NO;
}



-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // convert touch coordinates to x and y
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    thePlayer.position = ccp(location.x, yLocationOfPlayer);
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // convert touch coordinates to x and y
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    thePlayer.position = ccp(location.x, yLocationOfPlayer);
}



// on "dealloc" you need to release all your retained objects
-(void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
