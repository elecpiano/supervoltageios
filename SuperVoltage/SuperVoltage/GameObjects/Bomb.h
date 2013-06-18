//
//  Cloud.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-5.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SuperVoltageClasses.h"

@interface Bomb : BoardObjectBase {
    
}

@property (nonatomic) BOOL exploded;

-(id)initWithLayer:(CCLayer *)layer spritesheet:(CCSpriteBatchNode *)spritesheet;
-(void)trigger;
-(void)explode;
-(void)didExplode;

@end
