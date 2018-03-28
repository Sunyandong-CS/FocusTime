//
//  CountDownlabel.h
//  FocusTime
//
//  Created by 孙艳东 on 2018/3/22.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDownlabel : UILabel
/* 开始倒计时事件 */
@property (nonatomic, assign) NSUInteger count;


/**
 开始倒计时
 */
- (void)startCount;
@end
