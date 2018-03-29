//
//  SYDNotification.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/3/28.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import "SYDNotification.h"
@implementation SYDNotification

+ (void)postNotificationWithTimeInterval:(NSTimeInterval)time content:(UNMutableNotificationContent *)content completeHandler:(nullable void(^)(NSError *__nullable error))completionHandler{

    UNNotificationTrigger *timerTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"countDown" content:content trigger:timerTrigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        completionHandler(error);
    }];
    
}


@end
