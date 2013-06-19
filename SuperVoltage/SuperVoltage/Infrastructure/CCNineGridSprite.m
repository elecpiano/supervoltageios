//
//  CCNineGridSprite.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-19.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "CCNineGridSprite.h"


@implementation CCNineGridSprite{
    CCSprite *sprite_LT;
    CCSprite *sprite_T;
    CCSprite *sprite_RT;
    CCSprite *sprite_L;
    CCSprite *sprite_M;
    CCSprite *sprite_R;
    CCSprite *sprite_LB;
    CCSprite *sprite_B;
    CCSprite *sprite_RB;
}

-(id)initWithFile:(NSString *)filePath edge:(CGFloat)edge{
    if ((self = [super init])) {
        self.edge = edge;
        CGRect rect;
        
        //LT
        rect = CGRectMake(0, edge*2, edge, edge);
        sprite_LT = [CCSprite spriteWithFile:filePath rect:rect];
        [self addChild:sprite_LT];
        
        //T
        rect = CGRectMake(edge, edge*2, edge, edge);
        sprite_T = [CCSprite spriteWithFile:filePath rect:rect];
        [self addChild:sprite_T];
        
        //RT
        rect = CGRectMake(edge*2, edge*2, edge, edge);
        sprite_RT = [CCSprite spriteWithFile:filePath rect:rect];
        [self addChild:sprite_RT];
        
        //L
        rect = CGRectMake(0, edge, edge, edge);
        sprite_L = [CCSprite spriteWithFile:filePath rect:rect];
        [self addChild:sprite_L];
        
        //M
        rect = CGRectMake(edge, edge, edge, edge);
        sprite_M = [CCSprite spriteWithFile:filePath rect:rect];
        [self addChild:sprite_M];
        
        //R
        rect = CGRectMake(edge*2, edge, edge, edge);
        sprite_R = [CCSprite spriteWithFile:filePath rect:rect];
        [self addChild:sprite_R];
        
        //LB
        rect = CGRectMake(0, 0, edge, edge);
        sprite_LB = [CCSprite spriteWithFile:filePath rect:rect];
        [self addChild:sprite_LB];
        
        //B
        rect = CGRectMake(edge, 0, edge, edge);
        sprite_B = [CCSprite spriteWithFile:filePath rect:rect];
        [self addChild:sprite_B];
        
        //RB
        rect = CGRectMake(edge*2, 0, edge, edge);
        sprite_RB = [CCSprite spriteWithFile:filePath rect:rect];
        [self addChild:sprite_RB];
    }
    return self;
}

-(void)setSize:(CGSize)size{
    sprite_LT.position = ccp((self.edge-size.width)/2, (self.edge - size.height));
    sprite_T.position = ccp((self.edge-size.width)/2, (self.edge - size.height));
    sprite_RT.position = ccp((self.edge-size.width)/2, (self.edge - size.height));

}

@end
