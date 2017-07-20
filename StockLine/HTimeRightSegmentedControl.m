//
//  HTimeRightSegmentedControl.m
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "HTimeRightSegmentedControl.h"
#import "UIColor+YYAdd.h"

@implementation HTimeRightSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)items{
    self = [self initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRGB:0xF9F9F9];
        CGFloat iW = frame.size.width/items.count;
        for (int i = 0; i < items.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(iW * i, 0, iW, frame.size.height);
            [button setTitle:items[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRGB:0x888888] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRGB:0xFF723E] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.tag = 1000 + i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if (i==0) {
                button.selected = YES;
            }
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(iW, 3, 1, frame.size.height - 6)];
        line.backgroundColor = [UIColor colorWithRGB:0xEEEEEE];
        [self addSubview:line];
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    @autoreleasepool {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]] && sender != view) {
                UIButton *button = (UIButton *)view;
                button.selected = NO;
            }
        }
    }
    sender.selected = YES;
    if (self.clickBlock) {
        self.clickBlock(sender.tag - 1000);
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
