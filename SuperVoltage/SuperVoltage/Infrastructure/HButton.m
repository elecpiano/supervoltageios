//
//  HButton.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-6-13.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "HButton.h"
#import "SuperVoltage.h"

@implementation HButton{
    CCLabelTTF *textLabel;
    CCSprite *shineSprite;
}

#pragma mark - Lifecycle
+(id)itemWithLayer:(CCLayer *)layer text:(NSString *)text block:(void(^)(id sender))block{
	return [[self alloc] initWithLayer:layer text:text block:block];
}

-(id)initWithLayer:(CCLayer *)layer text:(NSString *)text block:(void(^)(id sender))block{
    if ((self = [super init])) {
        self.normalImage = [CCSprite spriteWithFile:@"HButtonNormal.png"];
        self.selectedImage = [CCSprite spriteWithFile:@"HButtonPressed.png"];
        _block = block;
        
        //text
        textLabel = [CCLabelTTF labelWithString:text fontName:@"Marker Felt" fontSize:dscale(32)];
        [self addChild:textLabel z:1];
        textLabel.position = ccp(self.normalImage.contentSize.width/2, self.normalImage.contentSize.height/2);
        
        //shine
        shineSprite = [CCSprite spriteWithFile:@"HButtonShine.png"];
        shineSprite.position = ccp(self.normalImage.contentSize.width/2, self.normalImage.contentSize.height);
        shineSprite.visible = NO;
        [self addChild:shineSprite z:2];
    }
    return self;
}

-(void)activate{
    [super activate];
}

-(void)selected{
    shineSprite.visible = YES;
    textLabel.fontSize = dscale(29);
    [super selected];
}

-(void)unselected{
    shineSprite.visible = NO;
    textLabel.fontSize = dscale(32);
    [super unselected];
}

@end
