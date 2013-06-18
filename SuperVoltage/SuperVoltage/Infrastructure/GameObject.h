//
//  GameObject.h
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-17.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameObject : CCNode {

}

//@property (nonatomic,strong) CCLayer *layer;
@property (nonatomic,strong) CCSprite *sprite;
//@property (nonatomic) CGPoint whereItShouldBe;

-(id)initWithLayer:(CCLayer *)layer;
-(void)setPosition:(CGPoint)position;
-(BOOL)containsTouch:(UITouch *)touch;

@end
