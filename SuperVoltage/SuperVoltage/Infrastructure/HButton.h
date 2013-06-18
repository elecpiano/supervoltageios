//
//  HButton.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-13.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HButton : CCMenuItemSprite {
    
}

-(id)initWithLayer:(CCLayer *)layer text:(NSString *)text block:(void(^)(id sender))block;
+(id)itemWithLayer:(CCLayer *)layer text:(NSString *)text block:(void(^)(id sender))block;

@end
