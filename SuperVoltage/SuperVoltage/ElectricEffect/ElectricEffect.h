//
//  ElectricEffect.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-28.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ElectricFlow.h"

@interface ElectricEffect : CCNode {
    
}

@property (nonatomic) int segments;
@property (nonatomic) CGFloat lifeSpan;
@property (nonatomic) CGFloat speedFactor;
@property (nonatomic) int zIndexForSprite;
@property (nonatomic,strong) NSMutableArray *electricFlows;

-(id)initWithSpritesheet:(CCSpriteBatchNode *)sheet frameName:(NSString *)frameName;
-(ElectricFlow *)addFlow;
-(void)clearFlows;

@end
