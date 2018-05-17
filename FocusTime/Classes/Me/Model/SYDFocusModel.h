//
//  SYDFocusModel.h
//  FocusTime
//
//  Created by 孙艳东 on 2018/5/10.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYDFocusModel : NSObject
/* 日期时间戳 */
@property (nonatomic, assign) NSTimeInterval dateTime;
/* 状态 */
@property (nonatomic, copy) NSString *status;
/* 日期 */
@property (nonatomic, copy) NSString *date;
/* 时间 */
@property (nonatomic, copy) NSString *finishTime;
/* setTime */
@property (nonatomic, copy) NSString *setTime;
/* 本次时间 */
@property (nonatomic, copy) NSString *actualTime;
/* 休息时间 */
@property (nonatomic, copy) NSString *restTime;
/* 程序异常时间 */
@property (nonatomic, copy) NSString *errorTime;
/* 以秒记的学习时间 */
@property (nonatomic, assign) NSInteger studyTime;
@end
