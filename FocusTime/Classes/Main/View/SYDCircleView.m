//
//  SYDCircleView.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/3/15.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import "SYDCircleView.h"

@implementation SYDCircleView

/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 绘制圆形图案
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x + 3, rect.origin.y + 3, rect.size.width - 6, rect.size.height - 6)];
    CGContextAddPath(context, path.CGPath);
    CGContextSetLineWidth(context, 3);
    UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25];
    [color setStroke];
    CGContextStrokePath(context);
}
@end
