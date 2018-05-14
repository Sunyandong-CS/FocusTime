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

/* section one */
@property (nonatomic, strong) NSArray *sectionOneArr;

/* section two */
@property (nonatomic, strong) NSArray *sectionTwoArr;
/* 选中的cell */
@property (nonatomic, strong) UITableViewCell *selectCell;
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
    // 2.初始化tableView数据
    [self setUpTableView];
    
    self.tableView.sectionHeaderHeight = 17;
    self.tableView.sectionFooterHeight = 3;
}

- (void)setUpTableView {
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 17)];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_img"]];
    imageV.userInteractionEnabled = YES;
    self.tableView.backgroundView = imageV;
    UITableViewCell *cell = self.tableView.visibleCells[1];
    NSUserDefaults *focus = [NSUserDefaults standardUserDefaults];
    NSString *hour = [focus objectForKey:@"durHours"];
    NSString *minute = [focus objectForKey:@"durMinutes"];
    if (hour != NULL && minute != NULL) {
        if ([hour  isEqual: @"0"]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@分钟", minute];
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@小时%@分钟",hour,minute];
        }
    } else {
        NSString *durMinutes = @"0";
        NSString *durHours = @"25";
        [focus setObject:durHours forKey:@"durHours"];
        [focus setObject:durMinutes forKey:@"durMinutes"];
    }
}


#pragma mark - 点击事件
- (IBAction)backBtnClick:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 初始化
- (void)initializeView {
    self.navigationItem.title = @"设置";
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self setNeedsNavigationBackground:0.0];
    
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
    return _focusPicker;
}


//- (PGDatePicker *)restPicker {
//    if (_restPicker == nil) {
//        _restPicker = datePickManager.datePicker;
//        _restPicker.delegate = self;
//    }
//    return _restPicker;
//}
#pragma mark - UITableViewDatasource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return self.sectionOneArr.count;
//    } else if(section == 1) {
//        return self.sectionTwoArr.count;
//    } else {
//        return 0;
//    }
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    UITableViewCell *cell = self.tableView.visibleCells[indexPath.row];
//
//    if (indexPath.section == 0) {
//        if (indexPath.row == 1) {
//            NSUserDefaults *focus = [NSUserDefaults standardUserDefaults];
//            NSString *hour = [focus objectForKey:@"durHours"];
//            NSString *minute = [focus objectForKey:@"durMinutes"];
//            if (hour != NULL && minute != NULL) {
//                if ([hour  isEqual: @"0"]) {
//                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@分钟", minute];
//                } else {
//                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@小时%@分钟",hour,minute];
//                }
//            }
//        } else {
//
//        }
//    }
//    return cell;
//}

#pragma mark - UItableviewDelegate
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",indexPath);
    if (indexPath.section == 0 ) {
        if(indexPath.row == 1 || indexPath.row == 2) {
            self.selectCell = self.tableView.visibleCells[indexPath.row];
            PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
            PGDatePicker *datePicker = datePickManager.datePicker;
            datePicker.delegate = self;
            datePicker.datePickerMode = PGDatePickerModeTime;
            [self presentViewController:datePickManager animated:false completion:nil];
        }
    }
    return indexPath;
}

#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSString *durMinutes = [NSString stringWithFormat:@"%li", (long)dateComponents.minute];
    NSString *durHours = [NSString stringWithFormat:@"%li", (long)dateComponents.hour];
    NSUserDefaults *focus = [NSUserDefaults standardUserDefaults];
    [focus setObject:durHours forKey:@"durHours"];
    [focus setObject:durMinutes forKey:@"durMinutes"];
    if (dateComponents.hour == 0) {
        self.selectCell.detailTextLabel.text = [NSString stringWithFormat:@"%li分钟",(long)dateComponents.minute];
    } else {
        self.selectCell.detailTextLabel.text = [NSString stringWithFormat:@"%li小时%li分钟",(long)dateComponents.hour,(long)dateComponents.minute];
    }
    
    NSLog(@"%@",dateComponents);
}
@end
