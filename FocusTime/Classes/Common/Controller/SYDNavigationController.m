//
//  SYDNavigationController.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/5/18.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import "SYDNavigationController.h"
#import "UIBarButtonItem+item.h"
@interface SYDNavigationController ()

@end

@implementation SYDNavigationController

+ (void)load {
    UINavigationBar *navbar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [navbar setTitleTextAttributes:textAttrs];
}

// 重写push方法，修改返回按钮样式
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem navBackButtonWithImage:@"backarrow" AndHighlightImage:@"backarrow" target:self action:@selector(back) title:@""];
    }
    
    // 真正执行跳转
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (void)setNeedsNavigationBackground:(CGFloat)alpha {
    // 导航栏背景透明度设置
    UIView *barBackgroundView = [[self.navigationController.navigationBar subviews] objectAtIndex:0];// _UIBarBackground
    UIImageView *backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];// UIImageView
    if (self.navigationController.navigationBar.isTranslucent) {
        if (backgroundImageView != nil && backgroundImageView.image != nil) {
            barBackgroundView.alpha = alpha;
        } else {
            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
            if (backgroundEffectView != nil) {
                backgroundEffectView.alpha = alpha;
            }
        }
    } else {
        barBackgroundView.alpha = alpha;
    }
    self.navigationController.navigationBar.clipsToBounds = alpha == 0.0;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsNavigationBackground:0.0];
    // Do any additional setup after loading the view.
}


@end
