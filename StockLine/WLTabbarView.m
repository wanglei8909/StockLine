//
//  WLTabbarView.m
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "WLTabbarView.h"
#import "UIColor+YYAdd.h"

@implementation WLTabbarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *items = @[@"分时",@"日K",@"周K",@"月K",@"分钟"];
        self.backgroundColor = [UIColor colorWithRGB:0xF9F9F9];
        CGFloat iW = frame.size.width/items.count;
        CGFloat iH = frame.size.height;
        for (int i = 0; i < items.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i* iW, 0, iW, iH);
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
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 3 * iH, iW, 1)];
//        line.backgroundColor = [UIColor colorWithRGB:0xEEEEEE];
//        [self addSubview:line];
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender{
    if (sender.selected && sender.tag != 1004) {
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
