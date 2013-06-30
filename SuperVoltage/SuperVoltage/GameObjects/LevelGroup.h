//
//  LevelGroup.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-19.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LevelGroup : CCLayer {
    
}

-(id)addLevel:(NSString *)levelKey levelData:(NSDictionary *)levelData locked:(BOOL)locked stars:(int)starCount;

@end
