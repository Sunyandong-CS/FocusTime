//
//  SYDStatisticController.h
//  FocusTime
//
//  Created by 孙艳东 on 2018/4/23.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYDStatisticController : UIViewController
/* status */
@property (nonatomic, copy) NSString *status;
/* studytime */
@property (nonatomic, assign) NSInteger studyTime;
/* Schedulestudytime */
@property (nonatomic, assign) NSInteger scheduleTime;
/* resttime */
@property (nonatomic, copy) NSString *restTime;

@end
