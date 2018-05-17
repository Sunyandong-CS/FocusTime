//
//  SYDConst.h
//  FocusTime
//
//  Created by 孙艳东 on 2018/3/14.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

// 获取导航栏和状态栏高度
#define getRectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height
@interface SYDConst : NSObject

@end
