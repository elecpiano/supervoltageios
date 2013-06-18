//
//  Bonus.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-2.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SuperVoltageClasses.h"

@interface Congratulation : GameObject {
    
}

@property (nonatomic) BonusType bonusType;
//@property (nonatomic,strong) CCSpriteFrame *spriteFrame_Combo;
//@property (nonatomic,strong) CCSpriteFrame *spriteFrame_Chain;

-(id)initWithLayer:(CCLayer *)layer spritesheet:(CCSpriteBatchNode *)spritesheet bonusType:(BonusType)bonusType;
-(void)show;

@end
