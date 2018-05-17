//
//  SYDTimeFormatter.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/5/15.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import "SYDTimeFormatter.h"

@implementation SYDTimeFormatter

+ (NSString *)syd_timeWithSecounds:(NSInteger)time {
    if (time <= 0) {
        return @"0s";
    }
    NSString * res = @"";
    NSInteger hours = time / (60 * 60);
    NSInteger mintues = (time - hours * 60 * 60) / 60;
    NSInteger secounds = time % 60;
    if (hours > 0) {
        res = [NSString stringWithFormat:@"%liH%lim%lis",(long)hours,(long)mintues,(long)secounds];
    } else if(mintues > 0) {
        res = [NSString stringWithFormat:@"%lim%lis",(long)mintues,(long)secounds];
    } else {
        res = [NSString stringWithFormat:@"%lis",(long)secounds];
    }
    return res;
}
@end
