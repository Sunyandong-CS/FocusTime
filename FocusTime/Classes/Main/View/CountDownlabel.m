//
//  CountDownlabel.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/3/22.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import "CountDownlabel.h"

@interface CountDownlabel ()
/* timer */
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation CountDownlabel

- (void)startCount {
    [self initTimer];
}

- (void)initTimer {
    if (self.count == 0) {
        self.count = 3;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown {
    if (self.count > 0) {
        self.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.count];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        // 字体变化大小
        NSValue *value1 = [NSNumber numberWithFloat:6.0];
        NSValue *value2 = [NSNumber numberWithFloat:3.0];
        NSValue *value3 = [NSNumber numberWithFloat:0.7];
        NSValue *value4 = [NSNumber numberWithFloat:1.0];
        animation.values = @[value1, value2, value3, value4];
        animation.duration = 0.5;
        [self.layer addAnimation:animation forKey:@"scalsTime"];
        self.count --;
    }else {
        [_timer invalidate];
        [self removeFromSuperview];
    }
}
@end
