//
//  UIBarButtonItem+item.m
//  budejie
//
//  Created by mymac on 2017/9/5.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "UIBarButtonItem+item.h"

@implementation UIBarButtonItem (item)
+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)imageName AndHighlightImage:(NSString *)HImageName target:(id)target action:(SEL)action {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:HImageName] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containV = [[UIView alloc] initWithFrame:btn.bounds];
    [containV addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:containV];

}
+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)imageName AndSelImage:(NSString *)selImageName target:(id)target action:(SEL)action {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containV = [[UIView alloc] initWithFrame:btn.bounds];
    [containV addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:containV];
}

+ (UIBarButtonItem *)navBackButtonWithImage:(NSString *)imageName AndHighlightImage:(NSString *)highlightImageName target:(id)target action:(SEL)action title:(NSString *)title{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    // 设置按钮的点击事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
