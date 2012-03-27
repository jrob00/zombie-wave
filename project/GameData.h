//
//  GameData.h
//  zombie-wave
//
//  Created by Jason Roberts on 3/24/12.
//  Copyright 2012 Clover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameData : CCNode {
    
    int wave;
    int numberDeadToLevelUp;
    int maxNumberOfEnemies;
    
    BOOL soundMuted;
    
    NSUserDefaults *defaults;
}

+(GameData*) sharedData;
-(int) returnWave;
-(int) returnNumberOfDeadToLevelUp;
-(int) returnMaxNumberOfEnemies;
-(void) waveLevelUp;
-(void) resetGame;

-(void) turnSoundOff;
-(void) turnSoundOn;

-(BOOL) isSoundMuted;

@end
