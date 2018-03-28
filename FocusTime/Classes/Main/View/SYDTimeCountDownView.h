//
//  SYDTimeCountDownView.h
//  FocusTime
//
//  Created by 孙艳东 on 2018/3/16.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYDTimeCountDownView : UIView
/** 分钟 */
@property (weak, nonatomic) UILabel * minuteLabel;
/** 秒 */
@property (weak, nonatomic) UILabel * secondLabel;
/** : */
@property (weak, nonatomic) UILabel * middleLabel;
@end
