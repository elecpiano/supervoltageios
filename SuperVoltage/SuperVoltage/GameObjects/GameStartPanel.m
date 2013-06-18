//
//  GameStartPanel.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-13.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation GameStartPanel{
    int _level;
}

#pragma mark - Lifecycle
-(id)initWithLayer:(CCLayer *)layer{
    if ((self = [super initWithLayer:layer])) {
        self.zOrder = Z_INDEX_HOME_LAYER_PAUSE_PANEL;
    }
    return self;
}

#pragma mark - Level
-(void)setLevel:(int)level{
    _level = level;
    [super setTitle:[NSString stringWithFormat:NSLocalizedString(@"GameStart_Level", nil), level, nil]];
}

@end
