//
//  SYDTimeCountDownView.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/3/16.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import "SYDTimeCountDownView.h"

@implementation SYDTimeCountDownView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat minuteWidth = frame.size.width * 0.5 - 12;
        CGFloat middleX = minuteWidth + 2;
        CGFloat secondX = middleX + 22;
        CGFloat height = frame.size.height;
        
        UILabel * minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, minuteWidth, height)];
        minuteLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6];
        minuteLabel.font = [UIFont fontWithName:@"SFUIDisplay-Thin" size:46];
        minuteLabel.textAlignment = NSTextAlignmentRight;
        self.minuteLabel = minuteLabel;
        
        
        UILabel * middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(middleX, 0, 20, height)];
        middleLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6];
        middleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Thin" size:40];
        middleLabel.textAlignment = NSTextAlignmentCenter;
        self.middleLabel = middleLabel;
        
        UILabel * secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondX, 0, minuteWidth, height)];
        secondLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6];
        secondLabel.font = [UIFont fontWithName:@"SFUIDisplay-Thin" size:46];
        secondLabel.textAlignment = NSTextAlignmentLeft;
        self.secondLabel = secondLabel;
        
        [self addSubview:minuteLabel];
        [self addSubview:secondLabel];
        [self addSubview:middleLabel];
        
        minuteLabel.text = [NSString stringWithFormat:@"%.2d",00];
        middleLabel.text = @":";
        secondLabel.text = [NSString stringWithFormat:@"%.2d",00];
        
    }
    
    return self;
}

@end
