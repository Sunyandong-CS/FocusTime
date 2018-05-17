//
//  MeViewController.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/4/23.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import <JQFMDB.h>
#import "MeViewController.h"
#import "SYDStatisticCell.h"
#import "SYDTimeFormatter.h"
static NSString * const statisticCellId = @"statisticCell";

@interface MeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *statisticView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *todayTotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *TodayFocusTimes;
/* 今日专注时间 */
@property (nonatomic, assign) NSInteger todayFocusTime;
/* 今日专注数据 */
@property (nonatomic, strong) NSMutableArray<SYDFocusModel *> *modelArr;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
    [self loadData];
}

#pragma mark - 点击事件
- (IBAction)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 初始化
// 懒加载
- (NSMutableArray *)modelArr {
    if(_modelArr == nil) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (void)loadData {
    // 从数据库加载统计数据
    _todayFocusTime = 0;
    JQFMDB *db = [JQFMDB shareDatabase];
    NSArray<SYDFocusModel *> *arr = [db jq_lookupTable:@"time" dicOrModel:[SYDFocusModel class] whereFormat:nil];
    [self.modelArr addObjectsFromArray:arr];
    NSString *date = [self getCurrentDate];
    
    for (SYDFocusModel *data in arr) {
        if (data.date == date) {
            _todayFocusTime += data.studyTime;
        }
    }
    _TodayFocusTimes.text = [NSString stringWithFormat:@"%lu次",(unsigned long)arr.count];
    _todayTotalTimeLabel.text = [SYDTimeFormatter syd_timeWithSecounds:_todayFocusTime];
}

- (void)initializeView {
    self.navigationItem.title = @"个人中心";
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self setNeedsNavigationBackground:0.0];
    
    // 初始化statisticView
    self.statisticView.layer.cornerRadius = 4;
    self.statisticView.layer.masksToBounds = YES;
    
    // 初始化tableView
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    // 注册cell
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([SYDStatisticCell class]) bundle:nil] forCellReuseIdentifier:statisticCellId];
    
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


#pragma mark - UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = self.modelArr.count;
    if (indexPath.row != 0 && [self.modelArr[count - indexPath.row - 1].date isEqualToString:self.modelArr[count - indexPath.row].date]) {
        return 108 - 15;
    } else {
        return 108;
    }
    
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SYDStatisticCell *cell = [self.tableview dequeueReusableCellWithIdentifier:statisticCellId forIndexPath:indexPath];
    NSUInteger count = self.modelArr.count;
    cell.focusModel = self.modelArr[count - indexPath.row - 1];
    if (indexPath.row != 0 && [self.modelArr[count - indexPath.row - 1].date isEqualToString:self.modelArr[count - indexPath.row].date]) {
        cell.isShowDate = false;
    } else {
        cell.isShowDate = true;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _modelArr.count;
}


#pragma mark - 获取日期
- (NSString *)getCurrentDate {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"MM-dd"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}
@end
