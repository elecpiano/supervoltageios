//
//  GameOverPanel.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-8.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation GameOverPanel{

}

#pragma mark - Lifecycle
-(id)initWithLayer:(CCLayer *)layer spritesheet:(CCSpriteBatchNode *)spritesheet{
    if ((self = [super initWithLayer:layer])) {
        self.zOrder = Z_INDEX_BOARD_LAYER_PAUSE_PANEL;
        [super setTitle:NSLocalizedString(@"GameOver_Title", nil)];
    }
    return self;
}

@end
