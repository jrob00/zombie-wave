//
//  OptionsMenu.m
//  zombie-wave
//
//  Created by Jason Roberts on 3/27/12.
//  Copyright 2012 Clover. All rights reserved.
//

#import "OptionsMenu.h"
#import "MainGame.h"
#import "GameData.h"
#import "Constants.h"

@implementation OptionsMenu


+(id) node {
    return [[[self alloc] init] autorelease];
}

-(id) init {
    
    if ((self = [super init])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        screenWidth = size.width;
        screenHeight = size.height;
        
        // show our menus
        
        CCSprite *theBackground = [CCSprite spriteWithFile:@"menu_background.png"];
        [self addChild:theBackground z:-1];
        theBackground.position = ccp(screenWidth / 2, screenHeight / 2);
        
        
        CCMenuItem *resumeButton = [CCMenuItemImage itemFromNormalImage:@"resume_game.png" selectedImage:@"resume_game2.png" target:self selector:@selector(resumeGame)];
        CCMenuItem *newButton = [CCMenuItemImage itemFromNormalImage:@"new_game.png" selectedImage:@"new_game2.png" target:self selector:@selector(newGame)];
        
        mainMenu = [CCMenu menuWithItems:resumeButton, newButton, nil];
        mainMenu.position = ccp(screenWidth / 2, screenHeight / 2);
        [mainMenu alignItemsVerticallyWithPadding:15];
        [self addChild:mainMenu z:1];
        
        
        if ([[GameData sharedData] isSoundMuted] == NO) {
            
            // setup the menu with audio on
            [self setUpAudioMenuWithSoundOn];
            
        } else {
            
            // setup alternate menu with audio off
            [self setUpAudioMenuWithSoundOff];
        }
    }
    
    return self;
}


-(void)setUpAudioMenuWithSoundOff {
    
    [self removeChildByTag:tagForSoundMenu cleanup:NO];
    
    CCMenuItem *soundOffButton = [CCMenuItemImage itemFromNormalImage:@"soundOff.png" selectedImage:@"soundOff.png" target:self selector:@selector(turnSoundOff)];
    CCMenuItem *soundOnButton = [CCMenuItemImage itemFromNormalImage:@"soundOn_deactivated.png" selectedImage:@"soundOn.png" target:self selector:@selector(turnSoundOn)];
    
    CCMenu *soundMenu = [CCMenu menuWithItems:soundOffButton, soundOnButton, nil];
    soundMenu.position= CGPointMake(screenWidth / 2 , mainMenu.position.y - soundOffButton.contentSize.height * 2);
    [soundMenu alignItemsHorizontallyWithPadding:1];
    [self addChild:soundMenu z:2 tag:tagForSoundMenu];
    
}

-(void)setUpAudioMenuWithSoundOn {
    
    [self removeChildByTag:tagForSoundMenu cleanup:NO];
    
    CCMenuItem *soundOffButton = [CCMenuItemImage itemFromNormalImage:@"soundOff_deactivated.png" selectedImage:@"soundOff.png" target:self selector:@selector(turnSoundOff)];
    CCMenuItem *soundOnButton = [CCMenuItemImage itemFromNormalImage:@"soundOn.png" selectedImage:@"soundOn.png" target:self selector:@selector(turnSoundOn)];
    
    CCMenu *soundMenu = [CCMenu menuWithItems:soundOffButton, soundOnButton, nil];
    soundMenu.position= CGPointMake(screenWidth / 2 , mainMenu.position.y - soundOffButton.contentSize.height * 2 );
    [soundMenu alignItemsHorizontallyWithPadding:1];
    [self addChild:soundMenu z:2 tag:tagForSoundMenu];
    
}


-(void) turnSoundOff {
    
    [self setUpAudioMenuWithSoundOff];
    [[GameData sharedData] turnSoundOff];
}

-(void) turnSoundOn {
    
    [self setUpAudioMenuWithSoundOn];
    [[GameData sharedData] turnSoundOn];
}


-(void) resumeGame {
    
    [self removeFromParentAndCleanup:NO];
    
    [[MainGame sharedMainGame] resumeFromOptions];
}

-(void) newGame {
    
    [self removeFromParentAndCleanup:NO];
    
    [[MainGame sharedMainGame] newGameFromOptions];
}

@end
