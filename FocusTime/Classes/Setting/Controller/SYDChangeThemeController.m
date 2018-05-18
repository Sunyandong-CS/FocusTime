//
//  SYDChangeThemeController.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/5/17.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import "SYDChangeThemeController.h"
#import "SYDThemeCell.h"
#import "SYDConst.h"


#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define ViewMargin 6
#define Margin 4

@interface SYDChangeThemeController ()<UICollectionViewDelegate,UICollectionViewDataSource>
/* collectionView */
@property (nonatomic, weak) UICollectionView *collectionView;
/* 背景图 */
@property (nonatomic, weak) UIImageView *bgView;
@end

@implementation SYDChangeThemeController

static NSString * const SYDThemeCellId = @"SYDThemeCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setNeedsNavigationBackground:0.0];
    self.navigationItem.title = @"选择主题";
    [self setUpbackgroundView];
    [self setUpCollectionView];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    
    // Do any additional setup after loading the view.
}

- (void)setUpbackgroundView {
    CGRect frame = CGRectMake(0, 0, ScreenW, ScreenH);
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:frame];
    bgView.image = [UIImage imageNamed:@"background_img"];
    self.bgView = bgView;
    [self.view addSubview:bgView];
}
/**
 初始化collectionView
 */
- (void)setUpCollectionView {
    /**
     使用collectionView 注意事项
     1.使用流水布局
     2.cell必须要注册
     3.cell必须自定义
     */
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置UICollectionView的尺寸需要使用layout
    CGFloat itemW = (ScreenW - ViewMargin * 2 - Margin * 3) / 4;
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.minimumLineSpacing = Margin;
    layout.minimumInteritemSpacing = Margin;
    
    // 设置frame
    CGRect frame = CGRectMake(0, getRectNavAndStatusHight, ScreenW, ScreenH - getRectNavAndStatusHight);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alpha = 0.8;
    collectionView.contentInset = UIEdgeInsetsMake(6, 6, 6, 6);
    // 设置代理
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    // 添加View
    [self.bgView addSubview:collectionView];
    // 注册Cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SYDThemeCell class]) bundle:nil] forCellWithReuseIdentifier:SYDThemeCellId];
    
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYDThemeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYDThemeCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor darkGrayColor];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


@end
