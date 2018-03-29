//
//  SYDSettingViewController.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/3/24.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import "SYDSettingViewController.h"

@interface SYDSettingViewController ()

@end

@implementation SYDSettingViewController
#pragma mark - 点击事件
- (IBAction)backBtnClick:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.初始化页面
    [self initializeView];
}

#pragma mark - 初始化
- (void)initializeView {
    self.navigationItem.title = @"设置";
    
}

@end
