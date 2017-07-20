//
//  WLMinuteSelectionView.m
//  HNNniu
//
//  Created by wanglei on 2017/7/13.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "WLMinuteSelectionView.h"
#import "UIColor+YYAdd.h"

@implementation WLMinuteSelectionView

- (void)setHidden:(BOOL)hidden{
    CGRect frame = self.frame;
    if (hidden) {
        frame.size.height = 0;
        [UIView animateWithDuration:0.1 animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {
            [super setHidden:hidden];
        }];
    }else{
        [super setHidden:hidden];
        frame.size.height = 35 * 5;
        [UIView animateWithDuration:0.1 animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRGB:0xF9F9F9];
        NSArray *array = @[@"60分钟",@"30分钟",@"15分钟",@"5分钟",@"1分钟"];
        for (int i = 0 ; i < 5; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, i * frame.size.height/5, frame.size.width, frame.size.height/5);
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 1000 + i;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:[UIColor colorWithRGB:0x888888] forState:UIControlStateNormal];
            [self addSubview:button];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height/5, frame.size.width, 1)];
            line.backgroundColor = [UIColor colorWithRGB:0xEEEEEE];
            [button addSubview:line];
        }
        [super setHidden:YES];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *result = [super hitTest:point withEvent:event];
    if (!CGRectContainsPoint(self.bounds, point)) {
        [super setHidden:YES];
    }
    return result;
}

- (void)buttonClick:(UIButton *)sender{
    if (self.clickBlock) {
        self.clickBlock(sender.tag - 1000);
    }
    [self setHidden:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
