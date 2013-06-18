//
//  HomeLayer.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-9.
//  Copyright namiapps 2013年. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"

// HomeLayer
@interface HomeLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
}

// returns a CCScene that contains the HomeLayer as the only child
+(CCScene *) scene;

@end
