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

static NSString * const statisticCellId = @"statisticCell";

@interface MeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *todayTotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *TodayFocusTimes;
/* 今日专注数据 */
@property (nonatomic, strong) NSMutableArray *modelArr;
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
    JQFMDB *db = [JQFMDB shareDatabase];
    NSArray<SYDFocusModel *> *arr = [db jq_lookupTable:@"time" dicOrModel:[SYDFocusModel class] whereFormat:nil];
    [self.modelArr addObjectsFromArray:arr];
    for (int i = 0; i < arr.count; i ++) {
        NSLog(@"%fi",arr[i].dateTime);
    }
    _TodayFocusTimes.text = [NSString stringWithFormat:@"%lu次",(unsigned long)arr.count];
    
}

- (void)initializeView {
    self.navigationItem.title = @"今日统计";
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self setNeedsNavigationBackground:0.0];
    
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
    return 108;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SYDStatisticCell *cell = [self.tableview dequeueReusableCellWithIdentifier:statisticCellId forIndexPath:indexPath];

//    SYDFocusModel *model = [[SYDFocusModel alloc] init];
//    model.date = @"5月9日";
//    model.finishTime = @"13:49";
//    model.setTime = @"50分钟";
//    model.actualTime = @"50分钟";
//    model.restTime = @"5分钟";
//    model.errorTime = @"0分钟";
    cell.focusModel = self.modelArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _modelArr.count;
}

@end
