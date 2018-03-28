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
#import "CircleAnimation.h"
#import "CountDownlabel.h"
#import "SYDTimeCountDownView.h"
#import "SYDSettingViewController.h"

#define margin 5
#define btnH   32
#define btnW   32
#define lBtnX  0
#define rBtnX  [UIScreen mainScreen].bounds.size.width - 32
#define btnY [UIScreen mainScreen].bounds.size.height - 32
#define startBtnW 100
#define pauseAndExitBtnW 70
#define startBtnH 34
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

/* 圆形区域 */
@property (nonatomic, weak) SYDCircleView *circleV;
/* 倒计时显示的View */
@property (nonatomic, weak) SYDTimeCountDownView *timeV;
/* circleAnimation */
@property (nonatomic, weak) CircleAnimation *cirAnimation;
/* 番茄总计时长 */
@property (nonatomic, assign) NSUInteger totalTime;
/* 番茄当前时长 */
@property (nonatomic, assign) NSUInteger currentTime;
/* timer */
@property (nonatomic, assign) dispatch_source_t timer;
@end

@implementation SYDMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0.设置状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 1.初始化统计时间
    self.totalTime = 1500;
    [self setUpMainView];
    [self setUpTimeView];
}

#pragma mark - 初始化页面

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
    [settingBtn setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(gotoSettingPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    // 添加右上角个人中心按钮
    UIButton *meBtn = [[UIButton alloc] initWithFrame:CGRectMake(rBtnX - margin, margin + startBtnH, btnW, btnH)];
    [meBtn setBackgroundImage:[UIImage imageNamed:@"个人中心"] forState:UIControlStateNormal];
    [meBtn addTarget:self action:@selector(gotoUserDetailPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: meBtn];
    
    // 开始按钮
    UIButton *startBtn = [self setUpButtonWithFrame:CGRectMake(0, 0, startBtnW, startBtnH) bgColor:[UIColor colorWithRed:255 / 255.0 green:84 / 255.0 blue:84 / 255.0 alpha:1] alpha:1 centerX: self.view.centerX centerY:self.view.centerY * 1.4 fontSize:16 action:@selector(startBtnClick) title:@"开始计时"];
    self.startBtn = startBtn;
    [self.view addSubview:startBtn];
    
    // 继续按钮
    UIButton *resumeBtn = [self setUpButtonWithFrame:CGRectMake(0, 0, startBtnW, startBtnH) bgColor:[UIColor colorWithRed:83 / 255.0 green:186 / 255.0 blue:156 / 255.0 alpha:1] alpha:0 centerX: self.view.centerX centerY:self.view.centerY * 1.4 fontSize:16 action:@selector(resumeBtnClick) title:@"继续计时"];
    self.resumeBtn = resumeBtn;
    [self.view addSubview:resumeBtn];
    
    // 暂停按钮
    UIButton * pauseButton = [self setUpButtonWithFrame:CGRectMake(0, 0, pauseAndExitBtnW, startBtnH) bgColor:[UIColor clearColor] alpha:0 centerX:self.view.centerX centerY:self.view.centerY * 1.4 fontSize:14 action:@selector(pauseButtonClick) title:@"暂停"];
    pauseButton.layer.borderWidth = 1;
    pauseButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:pauseButton];
    self.pauseBtn = pauseButton;
    
    //退出按钮
    UIButton * exitButton = [self setUpButtonWithFrame:CGRectMake(0, 0, pauseAndExitBtnW, startBtnH) bgColor:[UIColor clearColor] alpha:0 centerX:self.view.centerX centerY:self.view.centerY * 1.4 fontSize:14 action:@selector(exitButtonClick) title:@"退出"];
    exitButton.layer.borderWidth = 1;
    exitButton.titleLabel.textColor = [UIColor redColor];
    exitButton.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:exitButton];
    self.exitBtn = exitButton;
    
    
}

/**
 自定义按钮添加方法
 */
- (UIButton *)setUpButtonWithFrame:(CGRect)frame bgColor:(UIColor *)color alpha:(CGFloat)alpha
                           centerX:(CGFloat)centerX centerY:(CGFloat)centerY
                          fontSize:(CGFloat)size action:(SEL)action title:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = color;
    button.alpha = alpha;
    button.centerX = centerX;
    button.centerY = centerY;
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
 初始化倒计时视图
 */
- (void)setUpTimeView {
    // 创建圆形区域
    SYDCircleView *circleV = [[SYDCircleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW * 0.62, ScreenW * 0.62)];
    circleV.centerX = self.view.centerX;
    circleV.centerY = self.view.centerY * 0.7;
    circleV.backgroundColor = [UIColor clearColor];
    self.circleV = circleV;
    [self.view addSubview:circleV];
    
    // 添加计时区域
    SYDTimeCountDownView *timeView = [[SYDTimeCountDownView alloc] initWithFrame:self.circleV.frame];
    self.timeV = timeView;
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
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if(self.totalTime <= 0) {
            dispatch_source_cancel(timer);
#warning TODO 弹出提示，本地通知完成一个番茄事件
        } else {
            // 更新时间显示 主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshCountdownLabel];
            });
        }
    });
    dispatch_resume(timer);
}

- (void)clearTimeLabel {
    self.timeV.minuteLabel.text = @"00";
    self.timeV.middleLabel.text = @":";
    self.timeV.secondLabel.text = @"00";
    //弹出休息页面  present一个新的控制器比较好
}

// 更新timelabel时间
- (void)refreshCountdownLabel {
    if(self.totalTime <= 0){ //倒计时结束，关闭
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
        
        self.totalTime--;
    }
}

#pragma mark ***点击事件***

- (void)gotoSettingPage {
    NSLog(@"点了设置");
    
    // Setting  修改从storyboard加载
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SYDSettingViewController" bundle:nil];
    SYDSettingViewController *setVC = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:setVC animated:YES];
    
}

- (void)gotoUserDetailPage {
    NSLog(@"点了个人中心");
}

/**
 点击开始按钮,按钮动画,计时器开始
 */
- (void)startBtnClick {
    NSLog(@"点击了开始按钮");
    
    // 开始倒计时动画 3 。2 。1
    CountDownlabel *countdownlabel = [[CountDownlabel alloc] initWithFrame:CGRectMake(0, 300, 200, 60)];
    countdownlabel.textAlignment = NSTextAlignmentCenter;
    countdownlabel.centerX = self.view.centerX;
    countdownlabel.centerY = self.view.centerY * 0.8;
    countdownlabel.textColor = [UIColor whiteColor];
    countdownlabel.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:countdownlabel];
    
    self.circleV.alpha = 0;
    self.timeV.alpha = 0;
    self.startBtn.alpha = 0;
    
    [countdownlabel startCount];
    
    // 按钮动画
    [UIView animateWithDuration:0.3 delay:4.0 options:0 animations:^{
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
        [self addCircleAnimation];
        
    }];
}

/**
   点击继续按钮,按钮动画,计时器继续
 */
- (void)resumeBtnClick {
    NSLog(@"点击了开始按钮");
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
    } completion:^(BOOL finished) {
        
        // stop timer ,时钟归位
        [self stopTimer];
        [self refreshCountdownLabel];
        [self.cirAnimation removeFromSuperview];
        
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
-(void) stopTimer{
    if(_timer){
        dispatch_source_cancel(_timer);
        _timer = nil;
        
        // 统计时间归位
        self.totalTime = 1500;
    }
}
@end
