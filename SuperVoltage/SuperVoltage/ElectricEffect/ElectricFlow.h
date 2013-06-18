//
//  ElectricFlow.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-27.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ElectricNode.h"

@interface ElectricFlow : CCNode {
    
}

@property (nonatomic) int segments;
@property (nonatomic) CGFloat lifeSpan;
@property (nonatomic) CGFloat speedFactor;
@property (nonatomic) int zIndexForSprite;

-(id)initWithSpritesheet:(CCSpriteBatchNode *)sheet frameName:(NSString *)frameName;
-(ElectricNode *)addNode:(CGPoint)fiducialPoint radius:(CGFloat)radius;
-(void)clearNodes;

@end
