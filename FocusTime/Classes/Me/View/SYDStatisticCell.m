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

@property (weak, nonatomic) IBOutlet UILabel *restTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTop;

@end
@implementation SYDStatisticCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setFrame:(CGRect)frame{
    
    frame.size.height -= 8;
    _bgView.layer.cornerRadius = 4;
    _bgView.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    [super setFrame:frame];
}

- (void)setIsShowDate:(Boolean)isShowDate {

    _isShowDate = isShowDate;
    _dateLabel.hidden = isShowDate == NO;
    if (!_isShowDate && _bgViewTop.constant > 15) {
        _bgViewTop.constant -= 15;
    }
    if (_isShowDate && _bgViewTop.constant < 15) {
        _bgViewTop.constant += 15;
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    // 布局子控件
}
- (void)setFocusModel:(SYDFocusModel *)focusModel {
    _focusModel = focusModel;
    
    // 设置控件内容
    _statusLabel.text = focusModel.status;
    if ([focusModel.status isEqualToString:@"成功"]) {
        [_statusLabel setTextColor:[UIColor greenColor]];
    } else {
        [_statusLabel setTextColor:[UIColor redColor]];
    }
    _dateLabel.text = focusModel.date;
    _timeLabel.text = focusModel.finishTime;
    _totalFocusTime.text = focusModel.setTime ;
    _setTimeLabel.text = [NSString stringWithFormat:@"设定时长: %@",focusModel.setTime];
    _restTimeLabel.text = [NSString stringWithFormat:@"休息时间: %@",focusModel.restTime];
    
}
@end
