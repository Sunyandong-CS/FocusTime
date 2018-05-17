//
//  SYDMainController.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/3/14.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import "SYDMainController.h"
#import "UIView+SYDFrame.h"
#import "SYDCircleView.h"
#import "SYDStatisticController.h"
#import "CircleAnimation.h"
#import "CountDownlabel.h"
#import "SYDTimeCountDownView.h"
#import "SYDSettingViewController.h"
#import "SYDNotification.h"
#import <JQFMDB.h>
#import "SYDFocusModel.h"
#import "SYDTimeFormatter.h"
#import <UserNotifications/UserNotifications.h>

#define margin 16
#define btnH   24
#define btnW   24
#define logoW  96
#define lBtnX  0
#define rBtnX  [UIScreen mainScreen].bounds.size.width - 24
#define btnY [UIScreen mainScreen].bounds.size.height - 24
#define startBtnW 128
#define pauseAndExitBtnW 70
#define startBtnH 32
#define statusBarH 20
#define animationW [UIScreen mainScreen].bounds.size.width * 0.2
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface SYDMainController ()
/* 开始按钮 */
@property (nonatomic, weak) UIButton *startBtn;
/* 暂停按钮 */
@property (nonatomic, weak) UIButton *pauseBtn;
/* 退出按钮 */
@property (nonatomic, weak) UIButton *exitBtn;
/* 继续按钮 */
@property (nonatomic, weak) UIButton *resumeBtn;
/* 设置按钮 */
@property (nonatomic, weak) UIButton *settingBtn;

/* 个人中心按钮 */
@property (nonatomic, weak) UIButton *meBtn;

/* 圆形区域 */
@property (nonatomic, weak) SYDCircleView *circleV;
/* logo View */
@property (nonatomic, weak) UIImageView *logoView;
/* 倒计时显示的View */
@property (nonatomic, weak) SYDTimeCountDownView *timeV;
/* circleAnimation */
@property (nonatomic, weak) CircleAnimation *cirAnimation;
/* 番茄总计时长 */
@property (nonatomic, assign) NSInteger totalTime;
/* 番茄当前时长 */
@property (nonatomic, assign) NSInteger currentTime;
/* 休息时间 */
@property (nonatomic, assign) NSInteger restTime;
/* 番茄时间 */
@property (nonatomic, assign) NSInteger tomatoTime;
/* 本次休息时间 */
@property (nonatomic, assign) NSInteger currScheduleRestTime;
/* timer */
@property (nonatomic, strong) dispatch_source_t timer;
/* 休息的timer */
@property (nonatomic, strong) dispatch_source_t restTimer;
/* 休息duilie */
@property (nonatomic, strong) dispatch_queue_t restQueue;
/* 判断timer是否被挂起，被挂起状态下的timer无法被释放，会出现错误 */
@property (nonatomic, assign) Boolean isSuspend;
/* setTimeStr */
@property (nonatomic, copy) NSString *setTimeStr;
@end

@implementation SYDMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getCurrentTime];
    
    // 0.设置状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setUpMainView];
    [self showLogo];
    [self setUpTimeView];
}

#pragma mark - 初始化页面

- (void)initializeCountTime {
    
    NSUserDefaults *focus = [NSUserDefaults standardUserDefaults];
    NSString *hour = [focus objectForKey:@"durHours"];
    NSString *minute = [focus objectForKey:@"durMinutes"];
    _totalTime = hour.integerValue * 3600 + minute.integerValue * 60;
    if (_totalTime <= 0) { // 默认时间25min
        _totalTime = 25 * 60;
    }
    _isSuspend = NO;
    _currentTime = 0;
    _restTime = 0;
    _currScheduleRestTime = 10;
    _tomatoTime = 25 * 60; // 番茄时间默认25 min
    
    if (hour.integerValue > 0 ) {
        self.setTimeStr = [NSString stringWithFormat:@"%@h%@m",hour,minute];
    } else if(minute.intValue > 0){
        self.setTimeStr = [NSString stringWithFormat:@"  %@m",minute];
    } else {
        self.setTimeStr = @"25m";
    }
}

/**
 初始化主页的视图
 */
- (void)setUpMainView {
    
    // 设置页面背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"background_img"];
    imageView.backgroundColor = [UIColor colorWithRed:6 / 255.0 green:139 / 255.0 blue:229 / 255.0 alpha:0.4];
    [self.view addSubview:imageView];
    
    //左上角设置按钮
    
    UIButton * settingBtn = [[UIButton alloc] initWithFrame:CGRectMake( margin , margin + startBtnH, btnW, btnH)];
    [settingBtn setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(gotoSettingPage) forControlEvents:UIControlEventTouchUpInside];
    self.settingBtn = settingBtn;
    [self.view addSubview:settingBtn];
    
    // 添加右上角个人中心按钮
    UIButton *meBtn = [[UIButton alloc] initWithFrame:CGRectMake(rBtnX - margin, margin + startBtnH, btnW, btnH)];
    [meBtn setBackgroundImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    [meBtn addTarget:self action:@selector(gotoUserDetailPage) forControlEvents:UIControlEventTouchUpInside];
    self.meBtn = meBtn;
    [self.view addSubview: meBtn];
    
    // 开始按钮
    UIButton *startBtn = [self setUpButtonWithFrame:CGRectMake(0, 0, startBtnW, startBtnH) bgImage:[UIImage imageNamed:@"startBtn"] alpha:1 centerX: self.view.centerX centerY:self.view.centerY * 1.4 fontSize:16 action:@selector(startBtnClick) title:@""];
    self.startBtn = startBtn;
    [self.view addSubview:startBtn];
    
    // 继续按钮
    UIButton *resumeBtn = [self setUpButtonWithFrame:CGRectMake(0, 0, startBtnW, startBtnH) bgImage:[UIImage imageNamed:@""] alpha:0 centerX: self.view.centerX centerY:self.view.centerY * 1.4 fontSize:16 action:@selector(resumeBtnClick) title:@"继续计时"];
    resumeBtn.layer.borderWidth = 1;
    resumeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.resumeBtn = resumeBtn;
    [self.view addSubview:resumeBtn];
    
    // 暂停按钮
    UIButton * pauseButton = [self setUpButtonWithFrame:CGRectMake(0, 0, pauseAndExitBtnW, startBtnH) bgImage:[UIImage imageNamed:@""] alpha:0 centerX:self.view.centerX centerY:self.view.centerY * 1.4 fontSize:14 action:@selector(pauseButtonClick) title:@"暂停"];
    pauseButton.layer.borderWidth = 1;
    pauseButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:pauseButton];
    self.pauseBtn = pauseButton;
    
    //退出按钮
    UIButton * exitButton = [self setUpButtonWithFrame:CGRectMake(0, 0, pauseAndExitBtnW, startBtnH) bgImage:[UIImage imageNamed:@""] alpha:0 centerX:self.view.centerX centerY:self.view.centerY * 1.4 fontSize:14 action:@selector(exitButtonClick) title:@"退出"];
    exitButton.layer.borderWidth = 1;
    exitButton.titleLabel.textColor = [UIColor redColor];
    exitButton.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:exitButton];
    self.exitBtn = exitButton;
    
    
}

/**
 自定义按钮添加方法
 */
- (UIButton *)setUpButtonWithFrame:(CGRect)frame bgImage:(UIImage *)image alpha:(CGFloat)alpha
                           centerX:(CGFloat)centerX centerY:(CGFloat)centerY
                          fontSize:(CGFloat)size action:(SEL)action title:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    button.alpha = alpha;
    button.centerX = centerX;
    button.centerY = centerY;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    button.layer.cornerRadius = button.height * 0.5;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)addCircleAnimation {
    CGRect frame = CGRectMake(0, 0, ScreenW * 0.62, ScreenW * 0.62);
    CircleAnimation *circleAnimation = [[CircleAnimation alloc] initWithFrame:frame];
    circleAnimation.centerX = self.view.centerX;
    circleAnimation.centerY = self.view.centerY * 0.7;
    self.cirAnimation = circleAnimation;
    [self.view addSubview:circleAnimation];
    
}

/**
 默认显示的logoView
 */
- (void)showLogo {
    CGRect frame = CGRectMake(0, 0, logoW, logoW);
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:frame];
    logoView.image = [UIImage imageNamed:@"ic_launcher"];
    logoView.centerX = self.view.centerX;
    logoView.centerY = self.view.centerY * 0.7;
    logoView.backgroundColor = [UIColor darkGrayColor];
    logoView.layer.cornerRadius = logoView.width * 0.5;
    logoView.layer.masksToBounds = YES;
    self.logoView = logoView;
    [self.view addSubview:logoView];
    
    // 动画效果
}

/**
 初始化倒计时视图
 */
- (void)setUpTimeView {
    // 创建圆形区域
    SYDCircleView *circleV = [[SYDCircleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW * 0.62, ScreenW * 0.62)];
    circleV.centerX = self.view.centerX;
    circleV.centerY = self.view.centerY * 0.7;
    circleV.alpha = 0;
    circleV.backgroundColor = [UIColor clearColor];
    self.circleV = circleV;
    [self.view addSubview:circleV];
    
    // 添加计时区域
    SYDTimeCountDownView *timeView = [[SYDTimeCountDownView alloc] initWithFrame:self.circleV.frame];
    self.timeV = timeView;
    timeView.alpha = 0;
    [self.view addSubview:timeView];
    [self refreshCountdownLabel];
    
    
}

/**
 添加计时器(GCD方式)
 */
- (void)addTimer {
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    self.timer = timer;
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        NSLog(@"%@",[NSThread currentThread]);
        if(self.totalTime <= 0) {
            dispatch_source_cancel(_timer);
            // 恢复按钮状态, 主线程操作
            dispatch_async(dispatch_get_main_queue(), ^{
                [self exitButtonClick];
            });
        } else {
            // 更新时间显示 主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshCountdownLabel];
            });
        }
    });
    dispatch_resume(_timer);
}
- (void)addRestTimer {
    //开启专门的线程处理timer
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    self.restTimer = timer;
    dispatch_source_set_timer(_restTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_restTimer, ^{
        if(self.restTime >= self.currScheduleRestTime){ //休息结束，提示继续学习
            // 恢复按钮状态, 主线程操作
            dispatch_source_cancel(_restTimer);
            _restTimer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                // 弹出提示2
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"休息结束" message:@"休息时间到，请回到专注中~" preferredStyle:UIAlertControllerStyleAlert];
                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    // 休息时间减半，继续计时
                    self.currScheduleRestTime = self.currScheduleRestTime * 1.5;
                    [self addRestTimer];
//                    [self refreshRestTime];
                }]];
                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.currScheduleRestTime = self.currScheduleRestTime * 1.5;
                    [self resumeBtnClick];
                }]];
                [self presentViewController:alertCtrl animated:YES completion:nil];
            });
        } else {
            [self refreshRestTime];
        }
    });
    dispatch_resume(_restTimer);
}



#pragma mark - 保存模型到数据库
- (void)saveDataWithModel:(SYDFocusModel *)model {
    JQFMDB *db = [JQFMDB shareDatabase];
    [db jq_createTable:@"time" dicOrModel:model];
    [db jq_insertTable:@"time" dicOrModel:model];
}

- (void)clearTimeLabel {
    self.timeV.minuteLabel.text = @"00";
    self.timeV.middleLabel.text = @":";
    self.timeV.secondLabel.text = @"00";
    //弹出休息页面  present一个新的控制器比较好
}

// 更新timelabel时间
- (void)refreshCountdownLabel {
    if(self.totalTime < 0){ //倒计时结束，关闭
        self.timeV.minuteLabel.text = @"00";
        self.timeV.middleLabel.text = @":";
        self.timeV.secondLabel.text = @"00";
        
        //弹出休息页面  present一个新的控制器比较好
        
    }else{
        
        NSInteger minutes = self.totalTime / 60;
        NSInteger seconds = self.totalTime % 60;
        
        //设置界面的按钮显示 根据自己需求设置
        self.timeV.minuteLabel.text = [NSString stringWithFormat:@"%.2ld",(long)minutes];
        self.timeV.middleLabel.text = @":";
        self.timeV.secondLabel.text = [NSString stringWithFormat:@"%.2ld",(long)seconds];
        
        self.currentTime ++;
        self.totalTime --;
    }
}
// 更新休息时间
- (void)refreshRestTime {
    self.restTime ++;
    NSLog(@"%li",(long)self.restTime);
}

#pragma mark ***点击事件***

- (void)gotoSettingPage {
    NSLog(@"点了设置");
    
    // Setting  修改从storyboard加载
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SYDSettingViewController" bundle:nil];
    SYDSettingViewController *setVC = [storyboard instantiateInitialViewController];
    [self presentViewController:setVC animated:YES completion:nil];
    
}

- (void)gotoUserDetailPage {
    NSLog(@"点了个人中心");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MeViewController" bundle:nil];
    SYDSettingViewController *setVC = [storyboard instantiateInitialViewController];
    [self presentViewController:setVC animated:YES completion:nil];
}

/**
 点击开始按钮,按钮动画,计时器开始
 */
- (void)startBtnClick {
    NSLog(@"点击了开始按钮");
    // 1.初始化统计时间
    [self initializeCountTime];
    
    [self hideTopBtn];
    self.logoView.hidden = YES;
    self.timeV.alpha = 1;
    self.circleV.alpha = 1;
    
    
    // 开始倒计时动画 3 。2 。1
//    CountDownlabel *countdownlabel = [[CountDownlabel alloc] initWithFrame:CGRectMake(0, 300, 200, 60)];
//    countdownlabel.textAlignment = NSTextAlignmentCenter;
//    countdownlabel.centerX = self.view.centerX;
//    countdownlabel.centerY = self.view.centerY * 0.8;
//    countdownlabel.textColor = [UIColor whiteColor];
//    countdownlabel.font = [UIFont systemFontOfSize:30];
//    [self.view addSubview:countdownlabel];
    
    self.circleV.alpha = 0;
    self.timeV.alpha = 0;
    self.startBtn.alpha = 0;
    
//    [countdownlabel startCount];
    
    // 按钮动画
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
        self.startBtn.alpha = 0;
        self.pauseBtn.alpha = 1;
        self.exitBtn.alpha = 1;
        self.circleV.alpha = 1;
        self.timeV.alpha = 1;
        // 按钮出现
        [UIView animateWithDuration:0.4 animations:^{
            self.pauseBtn.centerX -= animationW;
            self.exitBtn.centerX += animationW;
        }];
    } completion:^(BOOL finished) {
        // 计时器开始计时
        [self addTimer];
        [self postNotification];
        [self addCircleAnimation];
        
    }];
}

/**
   点击继续按钮,按钮动画,计时器继续
 */
- (void)resumeBtnClick {
    NSLog(@"点击了开始按钮");
    if (_restTimer) {
        [self pauseRestTimer]; // 休息结束
    }

    // 按钮动画
    [UIView animateWithDuration:0.3 animations:^{
        self.resumeBtn.alpha = 0;
        self.pauseBtn.alpha = 1;
        self.exitBtn.alpha = 1;
        // 按钮出现
        [UIView animateWithDuration:0.4 animations:^{
            self.pauseBtn.centerX -= animationW;
            self.exitBtn.centerX += animationW;
        }];
    } completion:^(BOOL finished) {
        
        // 定时器继续
        [self resumeTimer];
        [self.cirAnimation setHidden:NO];
        
    }];
}

/**
 暂停按钮点击的操作
 */
- (void)pauseButtonClick {
    NSLog(@"点击了暂停按钮");
    
    [UIView animateWithDuration:0.2 animations:^{
        self.pauseBtn.centerX += animationW;
        self.pauseBtn.alpha = 0.0;
        self.exitBtn.centerX -= animationW;
        self.exitBtn.alpha = 0.0;
        self.resumeBtn.alpha = 1;
    } completion:^(BOOL finished) {
        
        // 定时器暂停
        [self pauseTimer];
        [self.cirAnimation setHidden:YES];
        
        // 后台记录休息时间
        if(!_restTimer) {
            [self addRestTimer];
        } else {
            [self resumeRestTimer];
        }
    }];
}

/**
 退出按钮点击的操作
 */
- (void)exitButtonClick {
    NSLog(@"点击了退出按钮");
    
    [UIView animateWithDuration:0.2 animations:^{
        self.pauseBtn.centerX += animationW;
        self.pauseBtn.alpha = 0.0;
        self.exitBtn.centerX -= animationW;
        self.exitBtn.alpha = 0.0;
        self.startBtn.alpha = 1;
//        [self resumeRestTimer]; // 处于suspend状态下的timer无法被释放
//        dispatch_source_cancel(_restTimer);
    } completion:^(BOOL finished) {
        
        self.logoView.hidden = NO;
        self.timeV.alpha = 0;
        self.circleV.alpha = 0;
        
        // stop timer ,时钟归位
        [self stopTimer];
        [self refreshCountdownLabel];
        [self.cirAnimation removeFromSuperview];
        [self showTopBtn];
        
        
    }];
}

#pragma mark - timer相关
/**************************timer管理*******************************/
-(void) pauseTimer{
    if(_timer){
        dispatch_suspend(_timer);
    }
}
-(void) resumeTimer{
    if(_timer){
        dispatch_resume(_timer);
    }
}
-(void) pauseRestTimer{
    if(_restTimer){
        _isSuspend = YES;
        dispatch_suspend(_restTimer);
    }
}
-(void) resumeRestTimer{
    NSLog(@"当前休息时间%i，继续休息。。。",self.restTime);
    if(_restTimer){
        dispatch_resume(_restTimer);
    }
}


-(void) stopTimer{
    if(_timer){
        dispatch_source_cancel(_timer);
        if (_restTimer) {
            if (_isSuspend) {
                [self resumeRestTimer];
            }
            dispatch_source_cancel(_restTimer); // 取消休息的timer
            _restTimer = nil;
        }
        _timer = nil;
        SYDFocusModel *model = [[SYDFocusModel alloc] init];
        
        model.dateTime = [[NSDate date] timeIntervalSince1970];
        NSLog(@"%f",model.dateTime);
        
        model.studyTime = self.currentTime;
        model.date = [self getCurrentDate];
        model.finishTime = [self getCurrentTime];
        model.setTime = self.setTimeStr;
        model.actualTime = self.setTimeStr;
        model.errorTime = @"  0m";
        model.restTime = [SYDTimeFormatter syd_timeWithSecounds:self.restTime];
        
        if (self.totalTime != 0) {
            // 任务不成功，跳转至统计页面，显示失败任务
            [self showStatisticPageWithStatus:@"专注失败"];
            model.status = @"专注失败";
            model.actualTime = [SYDTimeFormatter syd_timeWithSecounds:self.currentTime];
            
        } else {
            model.status = @"专注成功";
        }
        [self saveDataWithModel:model];
        
        // 统计时间归位
        [self initializeCountTime];
        
    }
}

- (void)showStatisticPageWithStatus:(NSString *)status {
    SYDStatisticController *staVC = [[SYDStatisticController alloc] initWithNibName:NSStringFromClass([SYDStatisticController class]) bundle:nil];
    
    staVC.status = status;
    staVC.studyTime = self.currentTime;
    staVC.scheduleTime = self.currentTime + self.totalTime;
    staVC.restTime = [SYDTimeFormatter syd_timeWithSecounds:self.restTime];
    [self presentViewController:staVC animated:YES completion:^{
       // 存数据
    }];
}
#pragma mark - 通知
- (void)postNotification {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"每刻";
    content.body = @"已完成一个番茄时间";
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    [SYDNotification postNotificationWithTimeInterval:self.tomatoTime content:content completeHandler:^(NSError * _Nullable error) {
        // 完成一个番茄钟的逻辑
        NSLog(@"完成一个番茄钟");
        
        #warning TODO 休息五分钟
        
    }];
}
#pragma mark - 顶部按钮显示控制
- (void)showTopBtn {
    self.settingBtn.hidden = NO;
    self.meBtn.hidden = NO;
}
- (void)hideTopBtn {
    self.settingBtn.hidden = YES;
    self.meBtn.hidden = YES;
}

#pragma mark - 工具方法
- (NSString *)getCurrentDate {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"MM-dd"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}
- (NSString *)getCurrentTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"HH:mm"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}

@end
