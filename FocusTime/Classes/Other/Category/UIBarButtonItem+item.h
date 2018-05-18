 //
//  UIBarButtonItem+item.h
//  budejie
//
//  Created by mymac on 2017/9/5.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (item)
+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)imageName AndHighlightImage:(NSString *)HImageName target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)imageName AndSelImage:(NSString *)selImageName target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)navBackButtonWithImage:(NSString *)imageName AndHighlightImage:(NSString *)highlightImageName target:(id)target action:(SEL)action title:(NSString *)title;



@end
