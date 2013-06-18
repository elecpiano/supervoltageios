//
//  Battery.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-8.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation Battery{
    CCLabelBMFont *batteryBalanceLabel;
}

#pragma mark - Lifecycle
-(id)initWithLayer:(CCLayer *)layer spritesheet:(CCSpriteBatchNode *)spritesheet{
    if ((self = [super initWithLayer:layer])) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Battery.png"];
        self.sprite = [CCSprite spriteWithSpriteFrame:frame];
        [spritesheet addChild:self.sprite z:Z_INDEX_TOP_BAR_BATTERY];
        self.position = BATTERY_POSITION;
        
        //balance label
        batteryBalanceLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"SVBMFont.fnt"];
        batteryBalanceLabel.alignment = kCCTextAlignmentLeft;
        batteryBalanceLabel.anchorPoint = ccp(0,0.7f);
        batteryBalanceLabel.position = self.position;// ccp(self.position.x + self.sprite.contentSize.width, self.position.y);
        [layer addChild:batteryBalanceLabel z:Z_INDEX_BOARD_LAYER_5];
    }
    return self;
}

-(void)onExit{
    [batteryBalanceLabel removeFromParentAndCleanup:YES];
    [super onExit];
}

#pragma mark - Balance
-(int)balance{
    return _balance;
}

-(void)setBalance:(int)balance{
    _balance = balance;
    if (batteryBalanceLabel) {
        [batteryBalanceLabel setString:[NSString stringWithFormat:@"%d", balance]];
    }
}

-(void)recharge:(int)amount{
    self.balance += amount;
}

-(void)discharge:(int)amount{
    self.balance -= amount;
}


@end
