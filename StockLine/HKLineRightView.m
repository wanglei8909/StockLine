//
//  HKLineRightView.m
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "HKLineRightView.h"
#import "UIColor+YYAdd.h"

@interface HKLineRightView ()

@property (nonatomic, copy) NSArray *items;

@end

@implementation HKLineRightView

/*
 KlineBottomType_VOL,
 KlineBottomType_BOLL,
 KlineBottomType_MACD,
 KlineBottomType_KDJ,
 KlineBottomType_RSI,
 KlineBottomType_OBV,
 KlineBottomType_WR,
 */

- (NSArray *)items{
    return  @[@"前复权",@"不复权",@"后复权",@"VOL",@"BOLL",@"MACD",@"KDJ",@"RSI",@"OBV",@"WR"];
}

- (void)setCanClick:(BOOL)canClick{
    @autoreleasepool {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                button.enabled = canClick;
            }
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRGB:0xF9F9F9];
        self.showsVerticalScrollIndicator = NO;
        CGFloat iW = frame.size.width;
        CGFloat iH = 30;
        for (int i = 0; i < self.items.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, i * iH, iW, iH);
            [button setTitle:self.items[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRGB:0x888888] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRGB:0xFF723E] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.tag = 1000 + i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if (i==0) {
                button.selected = YES;
            }
            if (i == 3) {
                button.selected = YES;
            }
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 3 * iH, iW, 1)];
        line.backgroundColor = [UIColor colorWithRGB:0xEEEEEE];
        [self addSubview:line];
        [self setContentSize:CGSizeMake(frame.size.width, self.items.count * iH)];
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    if (sender.tag < 1003) {
        for (int i = 0; i < 3; i ++) {
            UIButton *but = (UIButton *)[self viewWithTag:1000 + i];
            but.selected = NO;
        }
        
    }else{
        for (int i = 3; i < 10; i ++) {
            UIButton *but = (UIButton *)[self viewWithTag:1000 + i];
            but.selected = NO;
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
