//
//  MainGame.m
//  zombie-wave
//
//  Created by Jason Roberts on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainGame.h"
#import "Constants.h"
#import "GameData.h"

@implementation MainGame

static MainGame *sharedMainGame;

+(MainGame*) sharedMainGame {

    NSAssert(sharedMainGame != nil, @"not yet initialized!");
    return sharedMainGame;
}


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
        
        // give sharedMainGame a value of self so we can access self
        sharedMainGame = self;
        
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"musicloop.mp3" loop:YES];
        
        self.isTouchEnabled = YES;

        CGSize size = [[CCDirector sharedDirector] winSize];
        screenWidth = size.width;
        screenHeight = size.height;
        
        moveVar = 3;
        
        ammoKindInUse = kDefaultsAmmo;
        ammoKindToPickUp = kDefaultsAmmo;
        remainingAmmo = 30;
        ammoTypeStringName = @"round";
        
        numberOfEnemiesOnStage = 0;
        maxNumberOfEnemies = [[GameData sharedData] returnMaxNumberOfEnemies];
        
        numberDead = 0;
        numberDeadToLevelUp = [[GameData sharedData] returnNumberOfDeadToLevelUp];
        
        currentHealthUnits = fullHealthUnits;
        
        gameIsPaused = NO;
        
        wave = [[GameData sharedData] returnWave];
        CCLOG(@"wave is: %i", wave);
        CCLOG(@"max number of enemies is: %i", maxNumberOfEnemies);
        CCLOG(@"number dead to level up: %i", numberDeadToLevelUp);
        
        scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"hooge2.fnt"];
        scoreLabel.position = ccp(screenWidth * .9, 20);
        [self addChild:scoreLabel z:depthLevelScore];
        
        
        if (IS_IPAD) {
            
            CCLOG(@"this is an IPAD");
            
            remainingAmmoLabelLocation = ccp(550, 999);
            waveNumberLabelLocation = ccp(635, 999);
            ammoIconForMenuBarLocation = ccp(715, 999);
            healthMeterLocation = ccp(395, 999);
            menuBarLocation = ccp(50, 900);
            
        } else if (IS_IPHONE) {
            
            CCLOG(@"this is an IPHONE");

            remainingAmmoLabelLocation = ccp(230, 470);
            waveNumberLabelLocation = ccp(265, 470);
            ammoIconForMenuBarLocation = ccp(300, 470);
            healthMeterLocation = ccp(160, 468);
            menuBarLocation = ccp(20, 430);
            
        }
        
        
        // menu bar items
        
        remainingAmmoLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i", remainingAmmo] fntFile:@"hooge2.fnt"];
        [self addChild:remainingAmmoLabel z:depthLevelScore];
        remainingAmmoLabel.position = remainingAmmoLabelLocation;

        waveNumberLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i", wave] fntFile:@"hooge2.fnt"];
        [self addChild:waveNumberLabel z:depthLevelScore];
        waveNumberLabel.position = waveNumberLabelLocation;

        ammoIconForMenuBar = [CCSprite spriteWithFile:@"newAmmo.png"];
        [self addChild:ammoIconForMenuBar z:depthLevelScore];
        ammoIconForMenuBar.position = ammoIconForMenuBarLocation;

        CCSprite *theTopBar = [CCSprite spriteWithFile:@"topbar.png"];
        [self addChild:theTopBar z:depthLevelTopBar];
        theTopBar.position = ccp(screenWidth / 2, screenHeight - (theTopBar.contentSize.height / 2));
        
        CCSprite *theTopBarOverlay = [CCSprite spriteWithFile:@"topbar_overlay.png"];
        [self addChild:theTopBarOverlay z:depthLevelLightReflection];
        theTopBarOverlay.position = ccp(screenWidth / 2, screenHeight - (theTopBar.contentSize.height / 2));
        
        healthMeter = [CCSprite spriteWithFile:@"healthMeter.png"];
        [self addChild:healthMeter z:depthLevelScore];
        healthMeter.scaleX = 1;
        
        // position relative to the current scaleX
        healthMeter.position = ccp(
            (healthMeterLocation.x - healthMeter.contentSize.width / 2) + (healthMeter.scaleX * (healthMeter.contentSize.width / 2)), 
            healthMeterLocation.y
        );
        
        
        
        CCSprite *TempSprite = [CCSprite spriteWithFile:@"dude.png"];
        yLocationOfPlayer = TempSprite.contentSize.height / 2;
        
        thePlayer = [Player createPlayer:@"dude"];
        [self addChild:thePlayer z:depthLevelPlayer];
        thePlayer.position = ccp(screenWidth / 2, yLocationOfPlayer);
        
        thePlayerShadow = [CCSprite spriteWithFile:@"dude_shadow.png"];
        [self addChild:thePlayerShadow z:depthLevelPlayer - 1];
        thePlayerShadow.position = ccp(screenWidth / 2, yLocationOfPlayer);
        
        
        theBackground = [CCSprite spriteWithFile:@"background.png"];
        [self addChild:theBackground z:depthLevelBackground];
        theBackground.position = ccp(screenWidth / 2, screenHeight / 2 );
        
        
        // menu items
        
        CCMenuItem *menuButton = [CCMenuItemImage itemFromNormalImage:@"menu_button1.png" selectedImage:@"menu_button2.png" target:self selector:@selector(showOptions)];
        CCMenu *Menu = [CCMenu menuWithItems:menuButton, nil];
        Menu.position = menuBarLocation;
        [self addChild:Menu z:depthLevelOptionsMenuButton];
        
        
        
        // schedule events
        
        [self schedule:@selector(automaticFire:) interval:2.0f];
        [self schedule:@selector(mainGameLoop:)  interval:1.0f/60.0f];
        
        // add our enemies; increase/decrease time for faster spawn
        [self schedule:@selector(addToWaveAttack:)  interval:1.0f];
        
        [self waveAlertMessage];
        
	}
	return self;
}


#pragma mark Initial Game Message...


-(void) waveAlertMessage {
    
    if (wave == 1) {
        
        // display new game message
        waveAlert = [CCSprite spriteWithFile:@"newGame.png"];
        [self addChild:waveAlert z:depthLevelSigns];
        waveAlert.position = ccp(screenWidth / 2, screenHeight / 2);
        
    } else {

        waveAlert = [CCSprite spriteWithFile:@"nextWave.png"];
        [self addChild:waveAlert z:depthLevelSigns];
        waveAlert.position = ccp(screenWidth / 2, screenHeight / 2);

    }
    
    [self schedule:@selector(removeAlertMessage:) interval:2.0f];
}


-(void) removeAlertMessage:(ccTime) delta {
    
    [self removeChild:waveAlert cleanup:NO];
    [self unschedule:_cmd];
    
}


-(void) addToWaveAttack:(ccTime) delta {
    
    if (numberOfEnemiesOnStage < maxNumberOfEnemies) {
        
        // add one
        [self addEnemy];
    }
}

-(void) addEnemy {
    
    // return number in the range of 25 : screenWidth-50
    int randomX = arc4random() % (screenWidth - 50) + 25;
    
    
    Enemy* anEnemy = [Enemy createEnemy:@"zombie"];
    [self addChild:anEnemy z:depthLevelEnemy];
    anEnemy.position = ccp( randomX, screenHeight + 200);
    
    numberOfEnemiesOnStage++;
    
}


-(void) automaticFire:(ccTime) delta {
    
    CCLOG(@"fire");
    
    if (ammoKindInUse != kNinjaStarAmmo) {
        [thePlayer setUpFireAnimation];
        
        if ([[GameData sharedData] isSoundMuted] == NO) {
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"gunshot.caf"];
            [[SimpleAudioEngine sharedEngine] playEffect:@"shell_drop.caf"];
        }
        
    } else if (ammoKindInUse == kNinjaStarAmmo) {
        
        [thePlayer setUpThrowingAnimation];
        
        if ([[GameData sharedData] isSoundMuted] == NO) {
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"shell_drop.caf"];
        }
    
    }
    
    Bullet *theBullet = [Bullet createBullet:ammoTypeStringName];
    [self addChild:theBullet z:depthLevelBullet];
    theBullet.position = ccp(thePlayer.position.x, thePlayer.contentSize.height);
    
    
    // update our remaining ammo label
    remainingAmmo--;
    NSString *ammoString = [NSString stringWithFormat:@"%i", remainingAmmo];
    [remainingAmmoLabel setString:ammoString];
    
    
    if (remainingAmmo == 0) {
        [self unschedule:_cmd];
    }
}


// pretty much controls everything
-(void) mainGameLoop:(ccTime) delta {
    
    thePlayerShadow.position = ccp(thePlayer.position.x + thePlayerShadow.contentSize.width / 2, thePlayerShadow.contentSize.height / 2);
    
    [self enemyAndBulletCollisionHandler];
    [self checkIfEnemyGoesBelowStage];
}


-(void) checkIfEnemyGoesBelowStage {
    
    for (Enemy *someEnemy in self.children) {
        
        if ([someEnemy isKindOfClass:[Enemy class]]) {
            
            if (someEnemy.position.y < 0 - (someEnemy.enemySprite.contentSize.height / 2)) {
                
                // remove the enemy
                [self removeChild:someEnemy cleanup:YES];
                numberOfEnemiesOnStage--;
                
                // shake the screen
                if (alreadyShakingScreen == NO) {
                    
                    alreadyShakingScreen = YES;
                    [self schedule:@selector(showScreenDamage:) interval:1.0f/60.0f];
                }
                
                // subtract health
                [self healthMeterDamage];
                
                CCLOG(@"removing enemy");
                
                break;
            }
            
        }
        
    }
    
}


-(void) healthMeterDamage {
    
    currentHealthUnits = currentHealthUnits - 10;
    healthMeter.scaleX = currentHealthUnits / fullHealthUnits;
    
    // position relative to the current scaleX
    healthMeter.position = ccp(
        (healthMeterLocation.x - healthMeter.contentSize.width / 2) + (healthMeter.scaleX * (healthMeter.contentSize.width / 2)), 
        healthMeterLocation.y
    );
    
    // check for game end
    if (currentHealthUnits <= 0) {
        
        [self gameOver];
        [self unschedule:@selector(automaticFire:)];
        [self unschedule:@selector(mainGameLoop:)];
    }
}


-(void) showScreenDamage:(ccTime) delta {
    
    // tint the background red
    theBackground.color = ccRED;
    
    damageCounter++;
    
    if (damageCounter < 10) {
        
        self.position = ccp(self.position.x, self.position.y - 2);
    
    } else if (damageCounter < 20) {

        self.position = ccp(self.position.x, self.position.y + 2);

    } else if (damageCounter < 30) {

        self.position = ccp(self.position.x, self.position.y - 1);

    } else if (damageCounter < 40) {

        self.position = ccp(self.position.x, self.position.y + 1);

    } else {
        
        [self unschedule:_cmd];
        
        // reset the background color
        theBackground.color = ccc3(255, 255, 255);
        
        self.position = ccp(0,0);
        alreadyShakingScreen = NO;
        
        damageCounter = 0;
    }

}


-(void) enemyAndBulletCollisionHandler {
    
    for (Bullet *someBullet in self.children) {
        
        if ( [someBullet isKindOfClass:[Bullet class]] ) {
            
            CGPoint bulletPoint = ccp(someBullet.position.x, someBullet.bulletSprite.position.y);
            
            for (Enemy *someEnemy in self.children) {
                
                if ( [someEnemy isKindOfClass:[Enemy class]] ) {
                    
                    whereTheEnemyGotShot = ccp(someEnemy.position.x, someEnemy.position.y);
                    
                    if ( [self checkCollisionWithEnemy:bulletPoint:whereTheEnemyGotShot] == YES ) {
                        
                        // we shot someone!
                        CCLOG(@"we shot someone!");
                        
                        if (ammoKindInUse != kLaserAmmo) {
                            // remove the bullets but lasers can continue
                            [self removeChild:someBullet cleanup:YES];
                        }
                        
                        
                        if (someEnemy.enemyNeedsShootingTwice == YES && ammoKindInUse != kLaserAmmo) {
                            
                            // if not using laser ammo, you have to shoot the enemy twice
                            if (someEnemy.enemyShotOnceAlready == NO) {
                            
                                [someEnemy makeEnemyRed];
                                break;
                            }
                        }
                        
                        
                        // remove the struck enemy
                        [self removeChild:someEnemy cleanup:YES];
                        numberOfEnemiesOnStage--;
                        
                        // break out of here
                        aKillHasOccurred = YES;
                        break;
                        
                    }
                }
            }
            
            // break out of the second for loop if we broke out of the first
            if (aKillHasOccurred == YES) {
                
                break;
            }
        }
        
    }
    
    [self whatToDoAfterAKill];
    
}

-(void) whatToDoAfterAKill {
    
    if (aKillHasOccurred == YES) {
        
        aKillHasOccurred = NO;
        
        CCSprite *splatter = [CCSprite spriteWithFile:@"splatter.png"];
        [self addChild:splatter z:depthLevelSplatter];
        splatter.position = ccp(whereTheEnemyGotShot.x, whereTheEnemyGotShot.y);
        
        int diceRoll = arc4random() % 4; // range is 0 - 3
        
        if (diceRoll == 0) {
            splatter.flipX = YES;
        } else if (diceRoll == 1) {
            splatter.flipY = YES;
        } else if (diceRoll == 1) {
            splatter.flipX = YES;
            splatter.flipY = YES;
        }
        
        [self newAmmoDrop];
        
        [self addToScore];
        
        numberDead++;
        
        if ([self doWeLevelUp] == YES) {
            
            // level up
            [self levelUpEvents];
        
        }
        
    }

}


-(BOOL) checkCollisionWithEnemy: (CGPoint) bulletPointToCheck : (CGPoint) enemyPointToCheck {
    
    CCSprite *tempSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png", ammoTypeStringName]];
    
    float maxCollisionDistance = tempSprite.contentSize.width;
    float distanceBetween = ccpDistance(bulletPointToCheck, enemyPointToCheck);
    
    if (distanceBetween < maxCollisionDistance) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}


-(void) addToScore {
    
    score = score + 1;
    
    NSString* scoreString = [NSString stringWithFormat:@"%i", score];
    [scoreLabel setString:scoreString];
    
}


#pragma mark LEVEL UP

-(BOOL) doWeLevelUp {

    if (numberDead == numberDeadToLevelUp) {
        
        return YES;
        
    } else {
    
        return NO;
    
    }

}

-(void) levelUpEvents {
    
    // add one to the wave level number in GameData
    [[GameData sharedData] waveLevelUp];
    
    int diceRoll = arc4random() % 5; // 0-4
    
    switch (diceRoll) {
        case 0:
            [self transition0];
            break;
        case 1:
            [self transition1];
            break;
        case 2:
            [self transition2];
            break;
        case 3:
            [self transition3];
            break;
        case 4:
            [self transition4];
            break;
        
        default:
            [self transition1];
            break;
    }
    
}


-(void) transition0 {
    CCTransitionFadeDown *transition=[CCTransitionFadeDown transitionWithDuration:1 scene:[MainGame scene]];
    [[CCDirector sharedDirector] replaceScene:transition];
}
-(void) transition1 {
    CCTransitionFlipX *transition=[CCTransitionFlipX transitionWithDuration:1 scene:[MainGame scene]];
    [[CCDirector sharedDirector] replaceScene:transition];
}
-(void) transition2 {
    CCTransitionFade *transition=[CCTransitionFade transitionWithDuration:1 scene: [MainGame scene]];
    [[CCDirector sharedDirector] replaceScene:transition];
}
-(void) transition3 {
    CCTransitionFlipAngular *transition=[CCTransitionFlipAngular transitionWithDuration:1 scene:[MainGame scene]];
    [[CCDirector sharedDirector] replaceScene:transition];
}
-(void) transition4 {
    CCTransitionFadeTR *transition=[CCTransitionFadeTR transitionWithDuration:1 scene:[MainGame scene]];
    [[CCDirector sharedDirector] replaceScene:transition];
}
/*
 CCTransitionJumpZoom *transition=[CCTransitionJumpZoom transitionWithDuration:2 scene:[MainGame scene]];
 CCTransitionFadeBL *transition=[CCTransitionFadeBL transitionWithDuration:1 scene:[MainGame scene]];
 CCTransitionShrinkGrow *transition=[CCTransitionShrinkGrow transitionWithDuration:2.5 scene:[MainGame scene]];
 CCTransitionFadeTR *transition=[CCTransitionFadeTR transitionWithDuration:1 scene:[MainGame scene]];
 CCTransitionFlipAngular *transition=[CCTransitionFlipAngular transitionWithDuration:1 scene:[MainGame scene]];
 CCTransitionFlipX *transition=[CCTransitionFlipX transitionWithDuration:1 scene:[MainGame scene]];
 CCTransitionShrinkGrow *transition=[CCTransitionShrinkGrow transitionWithDuration:2.5 scene:[MainGame scene]]; 
*/

#pragma mark Game Over & New Game...

-(void) gameOver {
    
    // display new game message
    waveAlert = [CCSprite spriteWithFile:@"gameOver.png"];
    [self addChild:waveAlert z:depthLevelSigns];
    waveAlert.position = ccp(screenWidth / 2, screenHeight / 2);
    
    [self schedule:@selector(startNewGame:) interval:3.0f];
}


-(void) startNewGame:(ccTime) delta {
    
    [[GameData sharedData] resetGame];
    
    [self levelUpEvents];
    [self unschedule:_cmd];
}


-(void) newGameFromOptions {
    
    gameIsPaused = NO;
    [[GameData sharedData] resetGame];
    [self levelUpEvents];
}


#pragma mark Ammo Drop

-(void) newAmmoDrop {
    
    int diceRoll = arc4random() % 2; //0-1
    
    // drop ammo 50% of the time
    if (diceRoll == 0) {
    
        // remove existing ammo on stage
        [self removeChildByTag:tagForNewAmmo cleanup:NO];
        
        newAmmoOnStage = YES;
        
        // choose what kind of ammo that is going to be
        ammoKindToPickUp = arc4random() % 4; //0-3
        
        if (ammoKindToPickUp == kNinjaStarAmmo) {
            newAmmo = [CCSprite spriteWithFile:@"newAmmoNinja.png"];
            
        } else if (ammoKindToPickUp == kShotgunAmmo) {
            newAmmo = [CCSprite spriteWithFile:@"newAmmoShotgun.png"];

        } else if (ammoKindToPickUp == kLaserAmmo) {
            newAmmo = [CCSprite spriteWithFile:@"newAmmoLaser.png"];

        } else {
            newAmmo = [CCSprite spriteWithFile:@"newAmmo.png"];
        }
        
        
        [self addChild:newAmmo z:depthLevelAmmo tag:tagForNewAmmo];
        newAmmo.position = whereTheEnemyGotShot;
        
        whereTheNewAmmoGotDroppedAt = whereTheEnemyGotShot;
        
    }

}


-(BOOL) checkCollisionWithNewAmmo: (CGPoint) fingerLocationToCheck {
    
    float maxCollitionDistance = 40;
    
    CGPoint checkPoint = whereTheNewAmmoGotDroppedAt;
    float distanceBetween = ccpDistance(fingerLocationToCheck, checkPoint);
    
    if (distanceBetween < maxCollitionDistance) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}


-(void) completedNewAmmoPickup {

    [self removeChildByTag:tagForNewAmmo cleanup:NO];
    
    [self removeChild:ammoIconForMenuBar cleanup:NO];
    
    ammoKindInUse = ammoKindToPickUp;


    if (ammoKindInUse == kDefaultsAmmo) {
        
        ammoTypeStringName = @"round";
        ammoIconForMenuBar = [CCSprite spriteWithFile:@"newAmmo.png"];
        remainingAmmo = 30;
        
        [self unschedule:@selector(automaticFire:)];
        [self schedule:@selector(automaticFire:) interval:2.0f];
        
    } else if (ammoKindInUse == kLaserAmmo) {
        
        ammoTypeStringName = @"laser";
        ammoIconForMenuBar = [CCSprite spriteWithFile:@"newAmmoLaser.png"];
        remainingAmmo = 10;
        
        [self unschedule:@selector(automaticFire:)];
        [self schedule:@selector(automaticFire:) interval:3.0f];
        
    } else if (ammoKindInUse == kShotgunAmmo) {
        
        ammoTypeStringName = @"shotgun";
        ammoIconForMenuBar = [CCSprite spriteWithFile:@"newAmmoShotgun.png"];
        remainingAmmo = 20;
        
        [self unschedule:@selector(automaticFire:)];
        [self schedule:@selector(automaticFire:) interval:1.2f];
        
    } else if (ammoKindInUse == kNinjaStarAmmo) {
        
        ammoTypeStringName = @"ninja";
        ammoIconForMenuBar = [CCSprite spriteWithFile:@"newAmmoNinja.png"];
        remainingAmmo = 60;
        
        [self unschedule:@selector(automaticFire:)];
        [self schedule:@selector(automaticFire:) interval:0.5f];
        
    }
    
    // add the ammo icon again
    [self addChild:ammoIconForMenuBar z:depthLevelScore];
    ammoIconForMenuBar.position = ammoIconForMenuBarLocation;
    
    // update our remaining ammo label
    NSString *ammoString = [NSString stringWithFormat:@"%i", remainingAmmo];
    [remainingAmmoLabel setString:ammoString];
}




-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // convert touch coordinates to x and y
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (location.y < screenHeight / 4) {
        
        thePlayer.position = ccp(location.x, yLocationOfPlayer);
    }
    
    
    // make ammo touchable
    if (newAmmoOnStage == YES && [self checkCollisionWithNewAmmo:location] == YES) {
        
        // create a sequence
        CCSequence *seq = [CCSequence actions:
            [CCMoveTo actionWithDuration:0.5f position:ccp(screenWidth - 50, screenHeight)],
            [CCCallFunc actionWithTarget:self selector:@selector(completedNewAmmoPickup)], 
        nil];
        
        // assign that sequence
        [[self getChildByTag:tagForNewAmmo] runAction:seq];
    }
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // convert touch coordinates to x and y
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (location.y < screenHeight / 4) {
        thePlayer.position = ccp(location.x, yLocationOfPlayer);
    }
}


#pragma mark Option Menu

-(void) showOptions {
    
    if (gameIsPaused == NO) {
        
        gameIsPaused = YES;
        
        [self unschedule:@selector(automaticFire:)];
        [self unschedule:@selector(mainGameLoop:)];
        [self unschedule:@selector(addToWaveAttack:)];
        
        theOptions = [OptionsMenu node];
        theOptions.position = ccp(0,0);
        [self addChild:theOptions z:depthLevelOptionsMenu];
        
    }
    
}

-(void) resumeFromOptions {
    
    // xxxx we need to account for our gun types and set the interval appropriately
    [self schedule:@selector(automaticFire:) interval:2.0f];
    [self schedule:@selector(mainGameLoop:) interval:1.0f / 60.0f];
    [self schedule:@selector(addToWaveAttack:) interval:1.0f];
    
    // unpause
    gameIsPaused = NO;
}



-(BOOL) isGamePaused {
    
    return gameIsPaused;
    
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
