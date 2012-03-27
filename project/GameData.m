//
//  GameData.m
//  zombie-wave
//
//  Created by Jason Roberts on 3/24/12.
//  Copyright 2012 Clover. All rights reserved.
//

#import "GameData.h"
#import "Constants.h"

@implementation GameData

static GameData *sharedData = nil;

+(GameData*) sharedData {
    
    if (sharedData == nil) {
        sharedData = [[GameData alloc] init];
    }
    
    return sharedData;
}

-(id) init {
    
    if ((self = [super init])) {
        
        sharedData = self;
        
        [self waveLevelUp];
        
        defaults = [NSUserDefaults standardUserDefaults];
        soundMuted = [defaults boolForKey:@"soundMutedKey"];
    }
    
    return self;
}

-(int) returnWave {
    
    return wave;
}

-(int) returnNumberOfDeadToLevelUp {
    
    return numberDeadToLevelUp;
}

-(int) returnMaxNumberOfEnemies {
    
    return maxNumberOfEnemies;
}

-(void) waveLevelUp {
    
    wave++;
    maxNumberOfEnemies = initialNumberOfEnemiesOnStage + wave;
    numberDeadToLevelUp = initialNumberOfDeadToKill * wave;
    
}

-(void) resetGame {
    
    wave = 0;
    
}


-(void) turnSoundOn {

    soundMuted = NO;
    [defaults setBool:soundMuted forKey:@"soundMutedKey"];
    [defaults synchronize];
    
}

-(void) turnSoundOff {
    
    soundMuted = YES;
    [defaults setBool:soundMuted forKey:@"soundMutedKey"];
    [defaults synchronize];
}

-(BOOL) isSoundMuted {
    
    return soundMuted;
}

@end
