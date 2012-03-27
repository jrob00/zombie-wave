//
//  OptionsMenu.h
//  zombie-wave
//
//  Created by Jason Roberts on 3/27/12.
//  Copyright 2012 Clover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface OptionsMenu : CCNode {
    
    int screenWidth;
    int screenHeight;
    
    CCMenu *mainMenu;
    
}

-(void)setUpAudioMenuWithSoundOff;
-(void)setUpAudioMenuWithSoundOn;


@end
