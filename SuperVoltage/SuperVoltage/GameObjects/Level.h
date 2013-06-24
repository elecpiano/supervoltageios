//
//  Level.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-20.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Level : CCMenuItemSprite {
    
}

@property (nonatomic) int levelNumber;
@property (nonatomic) BOOL highlighted;
@property (nonatomic) BOOL locked;

-(id)initWithSpritesheet:(CCSpriteBatchNode *)spritesheet levelNumber:(int)levelNumber locked:(BOOL)locked stars:(int)starCount highlighted:(BOOL)highlighted;

@end
