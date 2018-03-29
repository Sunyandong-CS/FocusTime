//
//  SYDNotification.h
//  FocusTime
//
//  Created by 孙艳东 on 2018/3/28.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
@interface SYDNotification : NSObject

+ (void)postNotificationWithTimeInterval:(NSTimeInterval)time content:(UNMutableNotificationContent *)content completeHandler:(nullable void(^)(NSError *__nullable error))completionHandler;
@end
