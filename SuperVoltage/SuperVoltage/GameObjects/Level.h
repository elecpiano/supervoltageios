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

//@property (nonatomic) int levelNumber;
@property (nonatomic, strong) NSDictionary *levelData;
@property (nonatomic) BOOL highlighted;

-(id)initWithSpritesheet:(CCSpriteBatchNode *)spritesheet levelKey:(NSString *)levelKey levelData:(NSDictionary *)levelData locked:(BOOL)locked stars:(int)starCount;
@end
