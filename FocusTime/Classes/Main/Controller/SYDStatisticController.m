//
//  SYDStatisticController.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/4/23.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import "SYDStatisticController.h"
#import "SYDTimeFormatter.h"
@interface SYDStatisticController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *taskStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *studyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduleTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *restTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@end

@implementation SYDStatisticController
- (IBAction)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)ensure:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navBar setShadowImage:[[UIImage alloc] init]];
    _taskStatusLabel.text = _status;
    if (_studyTime / 3600 > 0) {
        NSInteger hours = _studyTime / 3600;
        NSInteger minutes = (_studyTime % 3600) / 60;
        NSInteger secounds = (_studyTime % 60);
        _studyTimeLabel.text = [NSString stringWithFormat:@"本次学习时长: %.2li:%.2li:%li",(long)hours,(long)minutes,(long)secounds];
    } else {
        NSInteger minutes = _studyTime / 60;
        NSInteger secounds = _studyTime % 60;
        _studyTimeLabel.text = [NSString stringWithFormat:@"本次学习时长:%.2li 分%.2li 秒",(long)minutes,(long)secounds];
    }
    if (_scheduleTime / 3600 > 0) {
        NSInteger hours = _scheduleTime / 3600;
        NSInteger minutes = (_scheduleTime % 3600) / 60;
        NSInteger secounds = (_scheduleTime % 60);
        _scheduleTimeLabel.text = [NSString stringWithFormat:@"设定学习时长:%.2li:%.2li:%li",(long)hours,(long)minutes,(long)secounds];
    } else {
        NSInteger minutes = _scheduleTime / 60;
        NSInteger secounds = _scheduleTime % 60;
        _scheduleTimeLabel.text = [NSString stringWithFormat:@"设定学习时长:%.2li 分%.2li 秒",(long)minutes,(long)secounds];
    }
    _restTimeLabel.text = [NSString stringWithFormat:@"本次休息时长:%@",_restTime];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self initializeView];
}
#pragma mark - 初始化
- (void)initializeView {
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _ensureBtn.layer.cornerRadius = 4;
    _ensureBtn.layer.masksToBounds = YES;
    
    // 设置背景图片
    
}

@end
