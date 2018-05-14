//
//  SYDStatisticCell.m
//  FocusTime
//
//  Created by 孙艳东 on 2018/5/10.
//  Copyright © 2018年 com.xidian.edu.cn. All rights reserved.
//

#import "SYDStatisticCell.h"
@interface SYDStatisticCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFocusTime;
@property (weak, nonatomic) IBOutlet UILabel *setTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *restTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end
@implementation SYDStatisticCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 8;
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    [super setFrame:frame];
}

- (void)setFocusModel:(SYDFocusModel *)focusModel {
    _focusModel = focusModel;
    
    // 设置控件内容
    _statusLabel.text = focusModel.status;
    _dateLabel.text = focusModel.date;
    _timeLabel.text = focusModel.finishTime;
    _totalFocusTime.text = focusModel.setTime ;
    _setTimeLabel.text = [NSString stringWithFormat:@"本次设定时间: %@",focusModel.setTime];
    _actualTimeLabel.text = [NSString stringWithFormat:@"本次专注时间: %@",focusModel.actualTime];
    _restTimeLabel.text = [NSString stringWithFormat:@"本次休息时间: %@",focusModel.restTime];
    _errorTimeLabel.text = [NSString stringWithFormat:@"程序异常时间: %@",focusModel.errorTime];
}
@end
