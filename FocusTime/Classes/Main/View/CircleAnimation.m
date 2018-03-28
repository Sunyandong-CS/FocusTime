//
//  CircleAnimation.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/3/28.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import "CircleAnimation.h"

@implementation CircleAnimation
// 绘制波纹动画
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    //添加动画
    NSInteger pulsingCount = 4;
    NSInteger animationDuration = 6;
    CALayer * animationLayer = [CALayer layer];
    
    for (NSInteger i = 0; i < pulsingCount; i++) {
        
        CALayer * pulsingLayer                 = [CALayer layer];
        pulsingLayer.frame                     = rect;
        pulsingLayer.borderColor               = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4].CGColor;
        pulsingLayer.borderWidth               = 1.5;
        pulsingLayer.cornerRadius              = rect.size.height / 2;
        
        CAMediaTimingFunction * defaultCurve   = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup * animationGroup      = [CAAnimationGroup animation];
        animationGroup.fillMode                = kCAFillModeBackwards;
        animationGroup.beginTime               = CACurrentMediaTime() + i * animationDuration / pulsingCount;
        animationGroup.duration                = animationDuration;
        animationGroup.repeatCount             = HUGE;
        animationGroup.timingFunction          = defaultCurve;
        
        CABasicAnimation * scaleAnimation      = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue               = @1.0;
        scaleAnimation.toValue                 = @1.15;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values                = @[@0, @0.4, @0.4, @0.4, @0.4, @0.3, @0.3, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes              = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        
        
        animationGroup.animations              = @[scaleAnimation, opacityAnimation];
        
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
        [self.layer addSublayer:animationLayer];
        
    }
    
}
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//
//    // 添加动画
//    NSInteger pulsingCount = 4;
//    NSInteger animationDuration = 6;
//    CALayer *animationLayer = [CALayer layer];
//    for (NSInteger i = 0; i < pulsingCount; i ++) {
//        // 创建动画的layer
//        CALayer *pulsingLayer = [CALayer layer];
//        pulsingLayer.frame = rect;
//        pulsingLayer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:1 green:1 blue:1 alpha:0.4]);
//        pulsingLayer.borderWidth = 1.5;
//        pulsingLayer.cornerRadius = rect.size.height / 2;
//
//        CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//
//        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
//        animationGroup.fillMode          = kCAFillModeBackwards;
//        animationGroup.beginTime         = CACurrentMediaTime() + i * animationDuration / pulsingCount;
//        animationGroup.duration          = animationDuration;
//        animationGroup.repeatCount       = HUGE;
//        animationGroup.timingFunction    = defaultCurve;
//        // 轮廓变化
//        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        scaleAnimation.fromValue = @1.0;
//        scaleAnimation.toValue   = @1.15;
//
//        // 关键帧动画
//        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//        opacityAnimation.values = @[@0, @0.4, @0.4, @0.4, @0.4, @0.3, @0.3, @0.3, @0.2, @0.1, @0];
//        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
//
//        animationGroup.animations = @[scaleAnimation, opacityAnimation];
//        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
//        [animationLayer addSublayer:pulsingLayer];
//        [self.layer addSublayer:animationLayer];
//    }
//}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
