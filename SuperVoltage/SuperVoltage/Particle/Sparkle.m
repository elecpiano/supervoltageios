//
//  Sparkle.m
//  SuperVoltage
//
//  Created by Lee Jason on 13-5-29.
//  Copyright 2013年 namiapps. All rights reserved.
//

#import "Sparkle.h"
#import "SuperVoltage.h"

@implementation Sparkle

-(id) init
{
	return [self initWithTotalParticles:55];
}

-(void)onEnter{
    [super onEnter];
    [self flashAt:A_PLACE_TO_HIDE];
}

-(id) initWithTotalParticles:(NSUInteger)p
{
	if( (self=[super initWithTotalParticles:p]) ) {
        
		// _duration
		_duration = kCCParticleDurationInfinity;
        
        // emits per second
		_emissionRate = 55;
        
		// set gravity mode.
		self.emitterMode = kCCParticleModeGravity;
        
		// Gravity Mode: gravity
		self.gravity = ccp(0,-599);
        
		// Gravity Mode: speed of particles
		self.speed = dscale(50);
		self.speedVar = dscale(50);
        
		// Gravity Mode: radial
		self.radialAccel = 0;
		self.radialAccelVar = 1;
        
		// Gravity mode: tagential
		self.tangentialAccel = 0;
		self.tangentialAccelVar = 1;
        
		// emitter position
//		self.position = (CGPoint) {
//			[[CCDirector sharedDirector] winSize].width / 2,
//			[[CCDirector sharedDirector] winSize].height + 10
//		};
//		self.posVar = ccp(10, 10);
        
		// _angle
		_angle = -90;
		_angleVar = 360;
        
		// _life of particles
		_life = 0.7;
		_lifeVar = 0.3;
        
		// size, in pixels
		_startSize = dscale(16.0f);
		_startSizeVar = dscale(8.0f);
		_endSize = kCCParticleStartSizeEqualToEndSize;
        
		// color of particles
		_startColor.r = 1.0f;
		_startColor.g = 1.0f;
		_startColor.b = 1.0f;
		_startColor.a = 1.0f;
		_startColorVar.r = 0.0f;
		_startColorVar.g = 0.0f;
		_startColorVar.b = 0.0f;
		_startColorVar.a = 0.0f;
		_endColor.r = 1.0f;
		_endColor.g = 1.0f;
		_endColor.b = 1.0f;
		_endColor.a = 0.0f;
		_endColorVar.r = 0.0f;
		_endColorVar.g = 0.0f;
		_endColorVar.b = 0.0f;
		_endColorVar.a = 0.0f;
        
        self.texture = [[CCTextureCache sharedTextureCache] addImage: @"Spark.png"];
        
		// additive
		self.blendAdditive = NO;
	}
    
	return self;
}

-(void)flashAt:(CGPoint)point{
    self.position = point;
    _active = YES;
    [self performSelector:@selector(didFlash) withObject:self afterDelay:0.1];
}

-(void)didFlash{
    _active = NO;
}

@end
