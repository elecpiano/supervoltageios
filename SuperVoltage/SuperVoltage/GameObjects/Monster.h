//
//  Monster2.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-6.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SuperVoltageClasses.h"

@interface Monster : BoardObjectBase <CCTouchOneByOneDelegate>{
}

@property (nonatomic) MonsterType monsterType;
@property (nonatomic) int health;
@property (nonatomic) int movingSpeedV;
@property (nonatomic) int movingSpeedH;
@property (nonatomic) BOOL shouldMoveForward;

@property (nonatomic,strong) NSString *spriteFrameName_Base;
@property (nonatomic,strong) CCSpriteFrame *spriteFrame_Normal;
@property (nonatomic,strong) CCSpriteFrame *spriteFrame_Angry;
@property (nonatomic,strong) CCSpriteFrame *spriteFrame_Shock1;
@property (nonatomic,strong) CCSpriteFrame *spriteFrame_Shock2;

-(id)initWithLayer:(CCLayer *)layer spritesheet:(CCSpriteBatchNode *)spritesheet monsterType:(MonsterType)monsterType;

-(void)moveForward;
//-(void)burn:(int)damage;
//-(void)didBurn;

@end
