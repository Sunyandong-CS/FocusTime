//
//  SYDStatisticCell.h
//  FocusTime
//
//  Created by 孙艳东 on 2018/5/10.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYDFocusModel.h"
@interface SYDStatisticCell : UITableViewCell

/* 专注数据模型 */
@property (nonatomic, strong) SYDFocusModel *focusModel;
/* 是否显示日期 */
@property (nonatomic, assign) Boolean isShowDate;
@end
