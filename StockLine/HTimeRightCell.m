//
//  HTimeRightCell.m
//  HNNniu
//
//  Created by wanglei on 2017/7/7.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "HTimeRightCell.h"

@interface HTimeRightCell ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *midLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation HTimeRightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat iW = 128/3;
        _midLabel = [[UILabel alloc] initWithFrame:CGRectMake(iW, 0, iW, 22)];
        _midLabel.backgroundColor = [UIColor clearColor];
        _midLabel.textAlignment = NSTextAlignmentCenter;
        _midLabel.font = [UIFont systemFontOfSize:13];
        [_midLabel setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:_midLabel];
        
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, iW, 22)];
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.font = [UIFont systemFontOfSize:13];
        [_leftLabel setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:_leftLabel];
        
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(iW * 2, 0, iW, 22)];
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.font = [UIFont systemFontOfSize:13];
        [_rightLabel setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:_rightLabel];
    }
    return self;
}

- (void)loadContent:(HTimeRightAdapterModel *)model{
    self.leftLabel.text = model.leftValue;
    self.midLabel.text = model.midValue;
    self.rightLabel.text = model.rightValue;
    self.leftLabel.textColor = model.leftColor;
    self.midLabel.textColor = model.midColor;
    self.rightLabel.textColor = model.rightColor;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
