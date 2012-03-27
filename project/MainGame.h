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
#import "Enemy.h"
#import "OptionsMenu.h"


@interface MainGame : CCLayer {
    
    // custom classes
    Player *thePlayer;
    OptionsMenu *theOptions;
    
    
    // CCSprites
    CCSprite *newAmmo;
    CCSprite *thePlayerShadow;
    CCSprite *theBackground;
    
    CCSprite *ammoIconForMenuBar;
    CCSprite *healthMeter;
    CCSprite *waveAlert; // says 'new game' initially, then 'new wave'
    
    
    // Labels
    CCLabelBMFont *scoreLabel;
    CCLabelBMFont *remainingAmmoLabel;
    CCLabelBMFont *waveNumberLabel;
    
    
    // ints
    int screenWidth;
    int screenHeight;
    int yLocationOfPlayer;
    int score;
    signed char moveVar;
    
    int ammoKindInUse;
    int ammoKindToPickUp;
    
    int numberOfEnemiesOnStage;
    int maxNumberOfEnemies;
    
    int numberDead;
    int numberDeadToLevelUp;
    
    int remainingAmmo;
    int damageCounter;
    
    int wave;
    
    
    // floats
    float currentHealthUnits;
    
    // bools
    BOOL aKillHasOccurred;
    BOOL newAmmoOnStage;
    BOOL alreadyShakingScreen;
    BOOL gameIsPaused;
    
    
    // NSStrings
    NSString *ammoTypeStringName;
    
    
    // CGPoints
    CGPoint whereTheEnemyGotShot;
    CGPoint whereTheNewAmmoGotDroppedAt;
    
    // the values in the following block vary between iPhone and iPad
    CGPoint remainingAmmoLabelLocation;
    CGPoint waveNumberLabelLocation;
    CGPoint ammoIconForMenuBarLocation;
    CGPoint menuBarLocation;
    CGPoint healthMeterLocation;
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

+(MainGame *) sharedMainGame;

-(void) addToScore;
-(void) addEnemy;
-(void) enemyAndBulletCollisionHandler;
-(BOOL) checkCollisionWithEnemy: (CGPoint) bulletPointToCheck : (CGPoint) enemyPointToCheck;
-(void) whatToDoAfterAKill;
-(BOOL) doWeLevelUp;
-(void) levelUpEvents;
-(void) newAmmoDrop;
-(BOOL) checkCollisionWithNewAmmo: (CGPoint) fingerLocationToCheck;
-(void) checkIfEnemyGoesBelowStage;
-(void) healthMeterDamage;
-(void) waveAlertMessage;
-(void) removeAlertMessage:(ccTime) delta;
-(void) gameOver;
-(BOOL) isGamePaused;


-(void) transition0;
-(void) transition1;
-(void) transition2;
-(void) transition3;
-(void) transition4;

-(void) showOptions;
-(void) resumeFromOptions;
-(void) newGameFromOptions;


@end
