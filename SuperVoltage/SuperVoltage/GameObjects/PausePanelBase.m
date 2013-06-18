//
//  PausePanelBase.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-13.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "SuperVoltage.h"

@implementation PausePanelBase{
    CCSprite *clapperBoardSprite;
    CCLabelTTF *titleLable;
    CGPoint myHiddenPosition;
}

#pragma mark - Lifecycle
-(id)initWithLayer:(CCLayer *)layer{
    if ((self = [super init])) {
        clapperBoardSprite = [CCSprite spriteWithFile:@"ClapperBoard.png"];
        [self addChild:clapperBoardSprite];
        self.position = myHiddenPosition = ccp(WIN_SIZE.width/2, WIN_SIZE.height + clapperBoardSprite.contentSize.height/2);
        [layer addChild:self];
                
        titleLable = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:dscale(48)];
        [self addChild:titleLable z:1];
    }
    return self;
}

-(void)onExit{
    [titleLable removeFromParentAndCleanup:YES];
    [super onExit];
}

#pragma mark - Title
-(void)setTitle:(NSString *)title{
    [titleLable setString:[NSString stringWithFormat:@"%@", title]];
}

#pragma mark - Show & Hide
-(void)show{
    id moveAction = [CCMoveTo actionWithDuration:PAUSE_PANEL_MOVEMENT_DURATION position:WINCENTER];
    [self runAction:moveAction];
}

-(void)hide{
    id moveAction = [CCMoveTo actionWithDuration:PAUSE_PANEL_MOVEMENT_DURATION position:myHiddenPosition];
    [self runAction:moveAction];
}

@end
