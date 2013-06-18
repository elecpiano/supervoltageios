//
//  ElectricNode.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-26.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ElectricNode : CCNode {
    
}

@property (nonatomic) CGPoint fiducialPoint;
@property (nonatomic) CGFloat radius;//10
@property (nonatomic) CGPoint velocity;
@property (nonatomic) CGFloat speedFactor;//1f

-(id)initWithFiducialPoint:(CGPoint)fiducialPoint radius:(CGFloat)radius speedFactor:(CGFloat)speedFactor;

@end
