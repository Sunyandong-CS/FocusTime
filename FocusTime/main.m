//
//  main.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/3/14.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
CFAbsoluteTime StartTime;

int main(int argc, char * argv[]) {
    // 记录开始时间
    StartTime = CFAbsoluteTimeGetCurrent();
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
