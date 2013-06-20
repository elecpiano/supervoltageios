//
//  CCNineGridSprite.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-19.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "CCNineGridSprite.h"


@implementation CCNineGridSprite{
    CCSpriteBatchNode *_spritesheet;
    
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

+(id)spriteWithFile:(NSString *)filePath edge:(CGFloat)edge{
    return [[CCNineGridSprite alloc] initWithFile:filePath edge:edge];
}

-(id)initWithFile:(NSString *)filePath edge:(CGFloat)edge{
    if ((self = [super init])) {
        self.edge = edge;
        CGRect rect;
        
        //LT
        rect = CGRectMake(0, 0, edge, edge);
        sprite_LT = [CCSprite spriteWithFile:filePath rect:rect];
        [self addChild:sprite_LT];
        
        //T
        rect = CGRectMake(edge, 0, edge, edge);
        sprite_T = [CCSprite spriteWithFile:filePath rect:rect];
        [self addChild:sprite_T];
        
        //RT
        rect = CGRectMake(edge*2, 0, edge, edge);
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
        rect = CGRectMake(0, edge*2, edge, edge);
        sprite_LB = [CCSprite spriteWithFile:filePath rect:rect];
        [self addChild:sprite_LB];
        
        //B
        rect = CGRectMake(edge, edge*2, edge, edge);
        sprite_B = [CCSprite spriteWithFile:filePath rect:rect];
        [self addChild:sprite_B];
        
        //RB
        rect = CGRectMake(edge*2, edge*2, edge, edge);
        sprite_RB = [CCSprite spriteWithFile:filePath rect:rect];
        [self addChild:sprite_RB];
    }
    return self;
}

+(id)spriteWithSpritesheet:(CCSpriteBatchNode *)spritesheet baseName:(NSString *)baseName edge:(CGFloat)edge{
    return [[CCNineGridSprite alloc] initWithSpritesheet:spritesheet baseName:baseName edge:edge];
}

-(id)initWithSpritesheet:(CCSpriteBatchNode *)spritesheet baseName:(NSString *)baseName edge:(CGFloat)edge{
    if ((self = [super init])) {
        _spritesheet = spritesheet;
        self.edge = edge;
        NSString *frameName;
        
        //LT
        frameName = [NSString stringWithFormat:@"%@%@",baseName,@"_LT.png"];
        sprite_LT = [CCSprite spriteWithSpriteFrameName:frameName];
        [_spritesheet addChild:sprite_LT];
        
        //T
        frameName = [NSString stringWithFormat:@"%@%@",baseName,@"_T.png"];
        sprite_T = [CCSprite spriteWithSpriteFrameName:frameName];;
        [_spritesheet addChild:sprite_T];
        
        //RT
        frameName = [NSString stringWithFormat:@"%@%@",baseName,@"_RT.png"];
        sprite_RT = [CCSprite spriteWithSpriteFrameName:frameName];
        [_spritesheet addChild:sprite_RT];
        
        //L
        frameName = [NSString stringWithFormat:@"%@%@",baseName,@"_L.png"];
        sprite_L = [CCSprite spriteWithSpriteFrameName:frameName];
        [_spritesheet addChild:sprite_L];
        
        //M
        frameName = [NSString stringWithFormat:@"%@%@",baseName,@"_M.png"];
        sprite_M = [CCSprite spriteWithSpriteFrameName:frameName];
        [_spritesheet addChild:sprite_M];
        
        //R
        frameName = [NSString stringWithFormat:@"%@%@",baseName,@"_R.png"];
        sprite_R = [CCSprite spriteWithSpriteFrameName:frameName];
        [_spritesheet addChild:sprite_R];
        
        //LB
        frameName = [NSString stringWithFormat:@"%@%@",baseName,@"_LB.png"];
        sprite_LB = [CCSprite spriteWithSpriteFrameName:frameName];
        [_spritesheet addChild:sprite_LB];
        
        //B
        frameName = [NSString stringWithFormat:@"%@%@",baseName,@"_B.png"];
        sprite_B = [CCSprite spriteWithSpriteFrameName:frameName];
        [_spritesheet addChild:sprite_B];
        
        //RB
        frameName = [NSString stringWithFormat:@"%@%@",baseName,@"_RB.png"];
        sprite_RB = [CCSprite spriteWithSpriteFrameName:frameName];
        [_spritesheet addChild:sprite_RB];
    }
    return self;
}

-(void)setSize:(CGSize)size{
    _size = size;
    //position
    sprite_LT.position = ccp((self.edge - size.width)/2 , (size.height-self.edge)/2 );
    sprite_T.position = ccp(0, (size.height-self.edge)/2);
    sprite_RT.position = ccp((size.width - self.edge)/2 , (size.height-self.edge)/2 );
    
    sprite_L.position = ccp((self.edge - size.width)/2, 0);
    sprite_M.position = ccp(0, 0);
    sprite_R.position = ccp((size.width-self.edge)/2, 0);
    
    sprite_LB.position = ccp((self.edge - size.width)/2, (self.edge - size.height)/2);
    sprite_B.position = ccp(0, (self.edge - size.height)/2);
    sprite_RB.position = ccp((size.width-self.edge)/2, (self.edge - size.height)/2);
    
    //scale
    sprite_M.scaleX = sprite_T.scaleX = sprite_B.scaleX = (size.width - self.edge*2)/self.edge;
    sprite_M.scaleY = sprite_L.scaleY = sprite_R.scaleY = (size.height - self.edge*2)/self.edge;
    
    //visibility
    sprite_LT.visible = YES;
    sprite_T.visible = YES;
    sprite_RT.visible = YES;
    sprite_L.visible = YES;
    sprite_M.visible = YES;
    sprite_R.visible = YES;
    sprite_LB.visible = YES;
    sprite_B.visible = YES;
    sprite_RB.visible = YES;
}

-(void)setSize2:(CGSize)size{
    _size = size;
    //position
    sprite_LT.position = ccp((self.edge - size.width)/2 , (size.height-self.edge)/2 );
    sprite_T.position = ccp(self.position.x, (size.height-self.edge)/2+self.position.y);
    sprite_RT.position = ccp((size.width - self.edge)/2 , (size.height-self.edge)/2 );

    sprite_L.position = ccp((self.edge - size.width)/2, 0);
    sprite_M.position = ccp(0, 0);
    sprite_R.position = ccp((size.width-self.edge)/2, 0);

    sprite_LB.position = ccp((self.edge - size.width)/2, (self.edge - size.height)/2);
    sprite_B.position = ccp(0, (self.edge - size.height)/2);
    sprite_RB.position = ccp((size.width-self.edge)/2, (self.edge - size.height)/2);
    
    //scale
    sprite_M.scaleX = sprite_T.scaleX = sprite_B.scaleX = (size.width - self.edge*2)/self.edge;
    sprite_M.scaleY = sprite_L.scaleY = sprite_R.scaleY = (size.height - self.edge*2)/self.edge;
    
    //visibility
    sprite_LT.visible = YES;
    sprite_T.visible = YES;
    sprite_RT.visible = YES;
    sprite_L.visible = YES;
    sprite_M.visible = YES;
    sprite_R.visible = YES;
    sprite_LB.visible = YES;
    sprite_B.visible = YES;
    sprite_RB.visible = YES;
}

@end
