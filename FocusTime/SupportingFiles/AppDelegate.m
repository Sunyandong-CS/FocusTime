//
//  AppDelegate.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/3/14.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import "AppDelegate.h"
#import "SYDMainController.h"
#import <UserNotifications/UserNotifications.h>

extern CFAbsoluteTime StartTime;
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.创建window
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    
    // 2.创建窗口的根控制器
    self.window.rootViewController = [[SYDMainController alloc] init];
    
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    
    // 本地通知注册
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
        UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"注册本地通知成功！");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                   NSLog(@"%@",settings);
                }];
            } else {
                NSLog(@"注册失败！");
            }
        }];
    } else if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    
    double launchTime = CFAbsoluteTimeGetCurrent() - StartTime;
    NSLog(@"%f",launchTime);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"专注时间";
    content.body = @"快回到应用,专注要失败了";
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    UNNotificationTrigger *timerTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.0 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"backgroundNotification" content:content trigger:timerTrigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if(error) {
            // 发送通知专注失败
            NSLog(@"专注失败");
        } else {
            // 回到应用
            NSLog(@"继续专注");
        }
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark - UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    UNNotificationPresentationOptions presentationOptions = UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge;
    
    completionHandler(presentationOptions);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"recive response %@",response);
    completionHandler();
}
@end
