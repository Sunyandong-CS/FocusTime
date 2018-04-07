//
//  SYDSettingViewController.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/3/24.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import "SYDSettingViewController.h"
#import <PGDatePicker/PGDatePickManager.h>
@interface SYDSettingViewController ()<PGDatePickerDelegate>

/* 时间选择管理者 */
@property (nonatomic, strong) PGDatePickManager *pickManager;
/* 专注时间选择 */
@property (nonatomic, weak) PGDatePicker *focusPicker;
/* 休息时间选择 */
@property (nonatomic, weak) PGDatePicker *restPicker;
@end

@implementation SYDSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.初始化页面
    [self initializeView];
}


#pragma mark - 点击事件
- (IBAction)backBtnClick:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 初始化
- (void)initializeView {
    self.navigationItem.title = @"设置";
}


#pragma mark - 懒加载View
- (PGDatePickManager *)pickManager {
    if (_pickManager == nil) {
        _pickManager = [[PGDatePickManager alloc] init];
    }
    return _pickManager;
}
- (PGDatePicker *)focusPicker {
    if (_focusPicker == nil) {
        _focusPicker = self.pickManager.datePicker;
        _focusPicker.delegate = self;
    }
    return _restPicker;
}


//- (PGDatePicker *)restPicker {
//    if (_restPicker == nil) {
//        _restPicker = datePickManager.datePicker;
//        _restPicker.delegate = self;
//    }
//    return _restPicker;
//}

#pragma mark - UItableviewDelegate
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeTime;
    [self presentViewController:datePickManager animated:false completion:nil];
}
#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"hello");
}
@end
