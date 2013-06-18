//
//  Battery.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-8.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SuperVoltageClasses.h"

@interface Battery : GameObject {
    int _balance;
}

//@property (nonatomic) int balance;

-(id)initWithLayer:(CCLayer *)layer spritesheet:(CCSpriteBatchNode *)spritesheet;
-(int)balance;
-(void)recharge:(int)amount;
-(void)discharge:(int)amount;

@end
