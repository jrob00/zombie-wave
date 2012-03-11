//
//  MainGame.m
//  zombie-wave
//
//  Created by Jason Roberts on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainGame.h"


@implementation MainGame

#define IS_IPHONE (!IS_IPAD)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)


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
        
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"musicloop.mp3" loop:YES];
        
        self.isTouchEnabled = YES;

        CGSize size = [[CCDirector sharedDirector] winSize];
        screenWidth = size.width;
        screenHeight = size.height;
        
        moveVar = 3;
        scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"hooge2.fnt"];
        scoreLabel.position = ccp(screenWidth * .9, 20);
        [self addChild:scoreLabel];
        
        
        if (IS_IPAD) {
            
            CCLOG(@"this is an IPAD");
            
            
            
        } else if (IS_IPHONE) {
            
            CCLOG(@"this is an IPHONE");
            
        }
        
        
        
        CCSprite *TempSprite = [CCSprite spriteWithFile:@"dude.png"];
        yLocationOfPlayer = TempSprite.contentSize.height / 2;
        
        thePlayer = [Player createPlayer:@"dude"];
        [self addChild:thePlayer z:10];
        thePlayer.position = ccp(screenWidth / 2, yLocationOfPlayer);
        
        
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
    
    
}

-(void) addToScore:(int) amountToAdd {

    score = score + amountToAdd;
    
    NSString* scoreString = [NSString stringWithFormat:@"%i", score];
    [scoreLabel setString:scoreString];
    
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
